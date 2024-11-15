class UsersController < ApplicationController
  def show
    @user = User.includes(:posts).find(params[:id])
    @posts = @user.posts
    @region = Region.find(params[:region_id])
  end
end

