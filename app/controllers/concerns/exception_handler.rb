
module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      response = {
        message: e.message,
        errors: e.backtrace[0],
      }
      puts response
      json_response(response, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      response = {
          message: e.message,
          backtrace: e.backtrace[0..2]
      }
      puts response
      json_response(response, :unprocessable_entity)
    end

    rescue_from ActiveRecord::RecordNotUnique do |e|
      response = {
          message: e.message,
          backtrace: e.backtrace[0..2]
      }
      puts response
      json_response(response, :conflict)
    end

    rescue_from JWT::DecodeError do |e|
      json_response({message: e.message}, :unauthorized)
    end

    rescue_from JWT::ExpiredSignature do |e|
      json_response({message: e.message}, :unauthorized)
    end

    rescue_from ArgumentError do |e|
      json_response({message: e.message}, :unauthorized)
    end

    rescue_from Apipie::ParamError do |e|
      json_response({message: e.message}, :bad_request)
    end

    rescue_from ActionController::BadRequest do |e|
      response = {
        message: e.message,
        errors: e.backtrace[0..2],
      }
      puts response
      json_response(response, :bad_request)
    end

    rescue_from ActionController::ParameterMissing do |e|
      json_response({message: e.message}, :bad_request)
    end

    rescue_from ActionController::UnpermittedParameters do |e|
      json_response({message: e.message}, :bad_request)
    end
    
    rescue_from CanCan::AccessDenied do |e|
      json_response({ message: e.message }, :forbidden)
    end
    
  end

end