class CommentsController < ApplicationController
  before_action :ensure_logged_in, only: [:new, :create, :edit, :update, :destroy]

  def index
  end

  def new
    @comment = Comment.new
  end

  def create

  end

  def show
  end

  def edit

  end

  def update
  end

  def destroy
  end
end
