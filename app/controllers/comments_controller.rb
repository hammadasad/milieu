class CommentsController < ApplicationController
  before_action :ensure_logged_in, only: [:new, :create, :edit, :update, :destroy]
  before_action :load_comment

  def index
    @comments = Comment.newest_first
    #Eventually order by the max number of upvotes - downvotes
  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      redirect_to comment_path(@comment), notice: "Comment posted"
    else
      flash.now[:alert] = "Could not post your comment"
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @comment.update_attributes(comment_params)
      redirect_to comments_path(@comment)
    else
      flash.now[:alert] = "Could not update comment"
      render :edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to root_path, flash: {notice: "Comment removed"}
  end

  private
    def comment_params
      params.require(:comment).permit(:text,:up_votes,:down_votes,:total_votes)
    end
    def load_comment
      @comment = Comment.find(params[:id])
    end
end
