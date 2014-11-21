class SharablesController < ApplicationController

  before_action :logged_in_user
  before_action :auth_user, only: [:show, :delete]

  def new
    @user = current_user
    @sharable = @user.sharables.build
  end

  def index
    @user = current_user
    if @user.admin?
      @sharables=Sharable.paginate(page: params[:page])
    else
      @sharables = @user.sharables.paginate(page: params[:page])
    end
  end

  def create
    @user=current_user
    @sharable = @user.sharables.create(sharable_params)
    if @sharable.save
      flash[:success] = "File was successfully uploaded."
      redirect_to action: 'index'
    else
      render action: 'new', alert: 'File could not be uploaded' 
    end
  end

  def show
    @sharable = Sharable.find(params[:id])
    send_file @sharable.file.path, :type => "application/#{@sharable.file_content_type}", :filename => @sharable.file_file_name
  end

  def destroy
    @sharable = Sharable.find(params[:id])
    @sharable.destroy
    flash[:success] = "File was successfully deleted."
    redirect_to action: 'index'
  end

  private
  
    def sharable_params
      params.require(:sharable).permit(:name, :file)
    end

    def auth_user
      redirect_to root_url unless (current_user.admin? || res_owner)
    end

    def res_owner
      if ((sharable=Sharable.find_by(id: params[:id])) && (sharable.user_id==current_user.id))
        return true
      else
        return false
      end
    end

end
