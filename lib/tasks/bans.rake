# frozen_string_literal: true

namespace :bans do
  task revoke_expired_bans: :environment do
    Ban.active.expired.find_each do |ban|
      ban.revoked!
    rescue StandardError => error
      Rails.logger.error("Failed to revoke expired Ban[#{ban.id}]: #{error.message}")
      Rails.logger.debug { error.backtrace.join("\n") }
    end
  end
end
