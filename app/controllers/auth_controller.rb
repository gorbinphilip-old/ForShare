class AuthController < ApplicationController

  before_action :logged_in_user

  def authorize
    @oauthclient=Oauthclient.find(params[:id])
    session[:oauth_id]=@oauthclient.id
    redirect_to @oauthclient.authorize_url+'?client_id='+
                @oauthclient.client_id+'&redirect_uri='+
                @oauthclient.redirect_url
  end

  def callback
    @user = current_user
    puts params[:code] #########
    if session[:oauth_id].blank? or params[:code].blank?
      flash[:danger] = "Failed to authorize (code missing)"
      redirect_to root_url
    else
      @oauthclient = Oauthclient.find(session[:oauth_id])
      if @auth=Auth.find_by(user_id:@user.id, oauthclient_id:@oauthclient.id)
        @auth.update_attributes(code: params[:code])
      else
        @auth = Auth.new(user_id:@user.id, oauthclient_id:@oauthclient.id, code: params[:code])
        @auth.save
      end
      session.delete(:oauth_id)
      get_token
    end
  end

  def get_token
    require 'net/http'
    require 'json'

    uri = URI(@oauthclient.token_url)
    get_token_params = { :client_id => @oauthclient.client_id, :client_secret => @oauthclient.client_secret, :redirect_uri => @oauthclient.redirect_url, :code => @auth.code }
    uri.query = URI.encode_www_form(get_token_params)
    response = Net::HTTP.get_response(uri)

    puts response.body ###########
    token=JSON.parse(response.body)['access_token']
    if not token.blank?
      @auth.update_attributes(token: token)
      flash[:success] = "App authorized"
      redirect_to sharables_url
    else
      flash[:danger] = "Failed to get token"
      redirect_to root_url
    end
  end

  def pack
    @user = current_user
    @sharables = @user.sharables
    @oauthclients=Oauthclient.joins(:auths).where(auths: {:user_id =>@user.id}) 
  end

  def share
    require 'net/http/post/multipart'
    require 'json'
    puts params ###############
    if params[:sharable_id].blank? and params[:oauthclient_id].blank?
      flash[:danger] = "Sharing failed"
      redirect_to root_url
    else
      @user = current_user
      @sharable=Sharable.find(params[:sharable_id])
      @oauthclient=Oauthclient.find(params[:oauthclient_id])
      @auth=Auth.find_by(user_id:@user.id, oauthclient_id:@oauthclient.id)
      add_params_names=params[:param_names]
      add_params_values=params[:param_values]
      add_params={}
      add_params[@sharable.name]= UploadIO.new(File.new(Rails.root+@sharable.file.path), @sharable.file_content_type, @sharable.name)
      if not add_params_names.blank?
        add_params_values.reverse!
        add_params_names.each do |param_name|
          param_value=add_params_values.pop
          if not param_value.blank?
            add_params[param_name]=param_value
          end
        end
      end
      uri = URI(@oauthclient.post_url)
      uri.query = URI.encode_www_form({:access_token => @auth.token})
      req = Net::HTTP::Post::Multipart.new uri, add_params
      res = Net::HTTP.start(uri.host, uri.port) do |http|
        http.request(req)
      end
      puts res.body ###########
      if JSON.parse(res.body)['success']==true
        flash[:success] = "Shared successfully"
      else
        flash[:danger] = "Sharing failed"
      end
      redirect_to root_url
    end
  end
end
