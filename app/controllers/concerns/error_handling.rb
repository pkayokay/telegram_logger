module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from Exception do |exception|
      Telegram::Backend::NotificationJob.perform_later(
        user_email: current_user,
        exception_class_name: exception.class.name,
        error_message: exception.message,
        class_name: self.class.name
      )

      raise exception
    end
  end
end
