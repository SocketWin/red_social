class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @post = current_user.posts.build
      @feed_posts = current_user.feed.paginate(page: params[:page], per_page: 25)
    end
  end

  def help
  end

  def about
  end

  def contact
  end

end
