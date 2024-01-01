class PostController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:publish]

    def list
        @posts = Post.all
    end

    def new
        @post = Post.new
    end

    def publish
      @post = Post.new(post_params)

      if check_post_existence
        render json: { error: 'A post with the same title exists' }, status: :unprocessable_entity
      else
        if @post.save
          render json: { message: 'Post successfully created' }, status: :created
        else
          render json: { error: 'Post creation failed:', errors: @post.errors.full_messages }, status: :unprocessable_entity
        end
      end

    end

    private

    def check_post_existence
        Post.exists?(title: post_params[:title])
    end

    def post_params
        params.require(:post).permit(:title, :content, :owner, :category)
    end


end
