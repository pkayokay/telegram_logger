require "telegram/bot"

class Telegram::Notification
  TELEGRAM_MESSAGE_LIMIT = 4096
  TELEGRAM_BOT_TOKEN = ENV["TELEGRAM_BOT_TOKEN"]
  TELEGRAM_CHAT_ID = ENV["TELEGRAM_CHAT_ID"]

  def send_backend_error(user_email:, exception_class_name:, error_message:, class_name:)
    message = build_error_log(
      type: "Backend Error",
      user_email: user_email,
      class_name: class_name,
      messages: [exception_class_name, error_message]
    )
    deliver(message)
  end

  def send_frontend_error(user_email:, error:, message:)
    message = build_error_log(
      type: "Frontend Error",
      user_email: user_email,
      messages: [message, error]
    )
    deliver(message)
  end

  private

  def build_error_log(type:, user_email:, class_name: nil, messages: [])
    message_parts = []
    message_parts << "❌ [#{type}]"
    message_parts << "- [User: #{user_email || "Unknown"}]"
    message_parts << "[#{class_name}]" if class_name
    message_parts << messages.compact.join(": ")

    message_parts.join(" ").slice(0, TELEGRAM_MESSAGE_LIMIT)
  end

  def deliver(message)
    if Rails.env.production?
      if TELEGRAM_BOT_TOKEN.blank? || TELEGRAM_CHAT_ID.blank?
        Rails.logger.error("Telegram Bot token or chat ID not configured")
        return
      end

      begin
        Telegram::Bot::Client.run(TELEGRAM_BOT_TOKEN) do |bot|
          bot.api.send_message(chat_id: TELEGRAM_CHAT_ID, text: message)
        end
      rescue => e
        Rails.logger.error("Failed to send Telegram message: #{e.message}")
      end
    else
      Rails.logger.info(message)
    end
  end
end
