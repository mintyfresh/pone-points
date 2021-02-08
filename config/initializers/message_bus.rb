# frozen_string_literal: true

Rails.application.config.after_initialize do
  MessageBus.load_subscribers

  Rails.application.reloader.before_class_unload do
    MessageBus.clear_subscribers
  end

  Rails.application.reloader.to_prepare do
    MessageBus.load_subscribers
  end
end
