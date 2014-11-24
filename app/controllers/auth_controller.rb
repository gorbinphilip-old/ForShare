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
    if session[:oauth_id] and params[:code]
      puts params[:code] #########
      @oauthclient = Oauthclient.find(session[:oauth_id])
      @auth = Auth.new(user_id:@user.id, oauthclient_id:@oauthclient.id,
                                    code: params[:code])
      @auth.save
      session.delete(:oauth_id)
      get_token
    else
      flash[:danger] = "Failed to get code"
      redirect_to root_url
    end
  end

  def get_token
    require 'net/http'
    require 'json'
    response = Net::HTTP.get_response("#{@oauthclient.token_url}",
                "?clent_id=#{@oauthclient.client_id}&
                    client_secret=#{@oauthclient.client_secret}&
                    redirect_uri=#{@oauthclient.redirect_url}&
                    code=#{@auth.code}")
    puts response.body ###########
    token=JSON.parse(response.body)['access_token']
    if token
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
    
  end

  def share
    puts params
    #do something :(
    flash[:success] = "Shared successfully"
    redirect_to root_url
  end

end
