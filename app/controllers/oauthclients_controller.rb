class OauthclientsController < ApplicationController

  before_action :logged_in_user
  before_action :admin_user, only: [:new, :create, :index]

  def new
    @oauthclient=Oauthclient.new
  end

  def index
    @oauthclients=Oauthclient.all
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

  private

    def oauthclient_params
      params.require(:oauthclient).permit(:client_id, :client_secret, :provider,
                                   :authorize_url, :token_url, :post_url,
                                    :redirect_url)
    end
end
