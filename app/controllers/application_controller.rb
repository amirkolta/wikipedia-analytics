class ApplicationController < ActionController::Base
  def render_invalid_param_error(message)
    render(
      json: {
        code: 3000,
        message: message,
      },
      status: :bad_request
    )
  end

  def render_failed_external_request(error)
    render(
      json: {
        code: 4000,
        message: error.message,
      },
      status: :bad_gateway
    )
  end
end
