class OauthclientsController < ApplicationController

  before_action :logged_in_user
  before_action :admin_user, only: [:new, :create,
                                     :edit, :update, :destroy]

  def new
    @oauthclient=Oauthclient.new
  end

  def index
    @oauthclients=Oauthclient.paginate(page: params[:page])
  end

  def show
    @oauthclient = Oauthclient.find(params[:id])
  end

  def create
    @oauthclient=Oauthclient.new(oauthclient_params)
    if @oauthclient.save
      flash[:success] = "added new OAuthClient"
      redirect_to root_url
    else
      flash[:success] = "failed to add OAuthClient"
      render 'new'
    end
  end

  def edit
    @oauthclient = Oauthclient.find(params[:id])
  end

  def update
    @oauthclient = Oauthclient.find(params[:id])
    if @oauthclient.update_attributes(oauthclient_params)
      flash[:success] = "OAuthClient updated"
      redirect_to @oauthclient
    else
      render 'edit'
    end
  end

  def destroy
    Oauthclient.find(params[:id]).destroy
    flash[:success] = "OAuthClient deleted"
    redirect_to oauthclients_url
  end

  private

    def oauthclient_params
      params.require(:oauthclient).permit(:client_id, :client_secret, :provider,
                                   :authorize_url, :token_url, :post_url,
                                    :redirect_url)
    end
end
