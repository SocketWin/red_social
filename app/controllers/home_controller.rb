class HomeController < ApplicationController
  def index
    if signed_in?
      @post = current_user.posts.build
      @feed_posts = current_user.feed.paginate(page: params[:page], per_page: 25)
    end
  end
end
