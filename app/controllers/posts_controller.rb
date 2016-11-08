class PostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]

  def destroy
  end

  def create
    @post = current_user.posts.create(post_params)
    if @post.save
      flash[:success] = "Post creado!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  private
  def post_params
    params.require(:post).permit(:comment)
  end

end
