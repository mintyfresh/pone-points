# frozen_string_literal: true

module Api
  module V1
    class PonesController < Api::BaseController
      def index
        authorize(Pone)
        @pones = policy_scope(Pone).order(:id).preload(avatar_attachment: :blob)

        render json: PoneBlueprint.render_as_json(@pones, root: :pones)
      end

      def show
        @pone = Pone.find_by!(slug: params[:slug])
        authorize(@pone)

        render json: PoneBlueprint.render_as_json(@pone, root: :pone)
      end
    end
  end
end
