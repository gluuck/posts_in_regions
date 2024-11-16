class RegionsController < ApplicationController
  def index
    @regions = Region.all
  end

  def show
    @region = Region.includes(:posts, :users).find(params[:id])
    @posts = @region.posts
  end
end

