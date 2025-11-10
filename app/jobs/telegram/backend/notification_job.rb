class Telegram::Backend::NotificationJob < ApplicationJob
  queue_as :default

  def perform(user_email:, error_message:, exception_class_name:, class_name:)
    Telegram::Notification.new.send_backend_error(
      user_email: user_email, 
      exception_class_name: exception_class_name,
      error_message: error_message,
      class_name: class_name
    )
  end
end
