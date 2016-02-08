class Admin::UsersController < Admin::ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :archive]
  
  # list all users
  def index
    @users = User.excluding_archived.order(:email)
  end
  
  # New for Create view from CRUD
  def new
    @user = User.new
  end
  
  # Create for Create method from CRUD
  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:notice] = "User has been created."
      redirect_to admin_users_path
    else
      flash.now[:alert] = "User has not been created."
      render "new"
    end
  end
  
  # Show for Read view from CRUD
  def show
  end
  
  # Edit for Update view from CRUD
  def edit
  end
  
  # Update for Update method from CRUD
  def update
    # if the password field isn't filled in, we don't need to update the password
    if params[:user][:password].blank?
      params[:user].delete(:password)
    end
    
    if @user.update(user_params)
      flash[:notice] = "User has been updated."
      redirect_to admin_users_path
    else
      flash.now[:alert] = "User has not been updated."
      render "edit"
    end
  end
  
  # Archive for Destroy method from CRUD
  # - we don't want to destroy users, just put them away for now
  def archive
    if @user == current_user
      flash[:notice] = "You cannot archive yourself!"
    else
      @user.archive
      flash[:notice] = "User has been archived."
    end
    
    redirect_to admin_users_path
  end
  
  private
  
    def user_params
      params.require(:user).permit(:email, :password, :admin)
    end
    
    def set_user
      @user = User.find(params[:id])
    end
end
