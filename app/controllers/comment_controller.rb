class CommentController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:publish, :delete]

    def list
      if params[:original].present?
        @comments = Comment.where(original_post: params[:original])
      else
        @comments = Comment.all
      end
  
      render json: @comments
    end


    def new
        @comment = Comment.new
    end

    def publish
      @comment = Comment.new(comment_params)
      if @comment.save
          render json: { message: 'Comment successfully created' }, status: :created
      else
          render json: { error: 'Comment creation failed:', errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end

    end

    def delete
      id = params[:id]
  
      if id.present?
        @comment = Comment.find_by(id: id)
  
        if @comment
          @comment.destroy
          render json: { message: 'Comment deleted successfully' }, status: :ok
        else
          render json: { error: 'Comment not found' }, status: :not_found
        end
      else
        render json: { error: 'Id is required parameters' }, status: :unprocessable_entity
      end
    end

    private

    def comment_params
        params.require(:comment).permit(:content, :owner, :original_post)
    end


end