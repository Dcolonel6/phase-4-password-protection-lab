class UsersController < ApplicationController
    wrap_parameters format: []

    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
    #rescue_from ActiveRecord::RecordNotFound, with: :render_user_not_found

    def create
        user = User.create!(users_params)
        session[:user_id] ||= user.id 
        render json: user, status: :created
    end

    def show
        user = find_user
        if user
            render json: user
        else
            render_user_unauthorized
        end
    end

    private
    def users_params
        params.permit(:username, :password_confirmation, :password)
    end

    def render_unprocessable_entity(error_object)
        render json: {errors: error_object.record.errors}, status: :unprocessable_entity
    end

    def find_user
        User.find_by(id: session[:user_id])
    end
    
    def render_user_unauthorized
        render json: {error: "User is not authorised"}, status: :unauthorized
    end
end
