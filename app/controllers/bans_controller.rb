# frozen_string_literal: true

class BansController < ApplicationController
  def index
    authorize(Ban)

    @bans = policy_scope(current_pone.bans).active.order(created_at: :desc, id: :desc)
  end
end
