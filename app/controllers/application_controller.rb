class ApplicationController < ActionController::API
    def auth_header
        # { Authorization: 'Bearer <token>' }
        request.headers['Authorization']
      end
    
    def decoded_token
        if auth_header
          token = auth_header.split(' ')[1]
          # header: { 'Authorization': 'Bearer <token>' }
          begin
            JWT.decode(token, 'okcool', true, algorithm: 'HS256')
          rescue JWT::DecodeError
            nil
          end
        end
      end
    
    def logged_in_user
        if decoded_token
        @author_id = decoded_token[0]['user']
    #   @author = Author.find_by(id: user_id)
        end
    end

    def logged_in?
        !!logged_in_user
    end

    def authorized
        render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
    end    
end
