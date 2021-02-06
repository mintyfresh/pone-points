# frozen_string_literal: true

class CreateApiKeys < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'pgcrypto'

    create_table :api_keys do |t|
      t.belongs_to :pone, null: false, foreign_key: true
      t.string     :token, null: false, index: { unique: true }
      t.string     :name, null: false
      t.string     :description
      t.integer    :requests_count, null: false, default: 0
      t.timestamp  :last_request_at
      t.timestamp  :revoked_at
      t.timestamps default: -> { 'NOW()' }

      t.index "encode(digest(token, 'sha256'), 'hex')",
              name:  'index_api_keys_on_token_hexdigest',
              using: 'hash'
    end
  end
end
