class Telegram::Frontend::NotificationJob < ApplicationJob
  queue_as :default

  def perform(user_email:, details:, title:)
    Telegram::Notification.new.send_frontend_error(
      user_email: user_email,
      error: details,
      message: title
    )
  end
end
