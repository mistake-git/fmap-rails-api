class ApplicationController < ActionController::API

  def auth
    pattern = /^Bearer /
    header  = request.headers['Authorization']
    token = header.gsub(pattern, '') if header && header.match(pattern)
    validator = FirebaseAuth.new(token)
    payload = validator.validate!
    @current_user = User.find_by(uid: payload["user_id"])
  end

  def require_auth
    render json: { result: message }, status: :unauthorized if @current_user.nil?
  end

end
