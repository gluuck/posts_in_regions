class Users::RegistrationsController < Devise::ConfirmationsController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user.region, notice: '#{@user.first_name} #{@user.last_name} was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end

  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email,
                                 :password,
                                 :password_confirmation,
                                 :first_name,
                                 :last_name,
                                 :patronymic,
                                 :region_id,
                                 :role)
  end

end