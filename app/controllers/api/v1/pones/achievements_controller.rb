# frozen_string_literal: true

module Api
  module V1
    module Pones
      class AchievementsController < Api::BaseController
        before_action :set_pone

        def index
          authorize(Achievement)
          @achievements = policy_scope(@pone.achievements).order(:id)

          render json: AchievementBlueprint.render_as_json(@achievements, root: :achievements, meta: index_meta)
        end

      private

        def set_pone
          @pone = Pone.find_by!(slug: params[:pone_slug])
          authorize(@pone, :show?)
        end

        # @return [Hash]
        def index_meta
          {
            links: {
              pone: api_v1_pone_path(@pone, format: :json)
            }
          }
        end
      end
    end
  end
end
