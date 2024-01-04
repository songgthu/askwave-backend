class PostController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:publish, :delete, :like, :unlike]

    def list
      if params[:owner].present?
        @posts = Post.where(owner: params[:owner])
      else
        @posts = Post.all
      end
  
      render json: @posts
    end

    def show
      title = params[:title]
      @post = Post.find_by(title: title)
      render :show
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

    def delete
      title = params[:title]
      owner = params[:owner]
  
      if title.present? && owner.present?
        @post = Post.find_by(title: title, owner: owner)
  
        if @post
          @post.destroy
          render json: { message: 'Post deleted successfully' }, status: :ok
        else
          render json: { error: 'Post not found' }, status: :not_found
        end
      else
        render json: { error: 'Title and owner are required parameters' }, status: :unprocessable_entity
      end
    end

    def like
      title = params[:title]
      username = params[:username]
      
      if title.present?
        @post = Post.find_by(title: title)
      
        if @post
          @post.liked_by ||= []
          unless @post.liked_by.include?(username)
            @post.increment!(:total_likes)
            @post.liked_by << username
            @post.save
    
            render json: { message: 'Post liked successfully', total_likes: @post.total_likes }, status: :ok
          else
            render json: { message: 'Post already liked by the user' }, status: :unprocessable_entity
          end
        else
          render json: { error: 'Post not found' }, status: :not_found
        end
      else
        render json: { error: 'Title is required parameters' }, status: :unprocessable_entity
      end
    end
    
  
    def unlike
      title = params[:title]
      username = params[:username]
  
      if title.present?
        @post = Post.find_by(title: title)
  
        if @post
          @post.decrement!(:total_likes)
          @post.liked_by.delete(username)
          @post.save
          render json: { message: 'Post unliked successfully', total_likes: @post.total_likes }, status: :ok
        else
          render json: { error: 'Post not found' }, status: :not_found
        end
      else
        render json: { error: 'Title are required parameters' }, status: :unprocessable_entity
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
