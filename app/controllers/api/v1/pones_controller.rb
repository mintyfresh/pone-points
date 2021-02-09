# frozen_string_literal: true

module Api
  module V1
    class PonesController < Api::BaseController
      before_action :set_pone, only: %i[show groups]

      def index
        authorize(Pone)
        @pones = policy_scope(Pone).order(:id).preload(avatar_attachment: :blob)

        render json: PoneBlueprint.render_as_json(@pones, root: :pones)
      end

      def show
        authorize(@pone)

        render json: PoneBlueprint.render_as_json(@pone, root: :pone)
      end

      def me
        @pone = api_key.pone
        authorize(@pone, :show?)

        render json: PoneBlueprint.render_as_json(@pone, root: :pone, view: :me)
      end

      def groups
        authorize(@pone, :show?) && authorize(Group, :index?)
        @groups = policy_scope(@pone.groups).order(:id).preload(:owner)

        render json: GroupBlueprint.render_as_json(@groups, root: :groups)
      end

    private

      def set_pone
        @pone = Pone.find_by!(slug: params[:slug])
      end
    end
  end
end
