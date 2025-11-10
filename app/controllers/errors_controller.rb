class ErrorsController < ApplicationController
  def create
    params = JSON.parse(request.body.read)

    Telegram::Frontend::NotificationJob.perform_later(
      user_email: current_user,
      title: params["title"],
      details: params["details"]
    )

    render json: {status: true}
  end
end
