# frozen_string_literal: true

module Api
  module V1
    class PonesController < Api::BaseController
      before_action :set_pone, only: %i[show groups]

      def index
        authorize(Pone)

        @pones = policy_scope(Pone).order(:id).preload(avatar_attachment: :blob)
        @pones = @pones.page(params[:page]).per(params[:count])

        render json: PoneBlueprint.render_as_json(@pones, root: :pones, meta: index_meta(@pones))
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
        @groups = @groups.page(params[:page]).per(params[:count])

        render json: GroupBlueprint.render_as_json(@groups, root: :groups, meta: index_meta(@groups))
      end

    private

      def set_pone
        @pone = Pone.find_by!(slug: params[:slug])
      end

      # @param relation [ActiveRecord::Relation]
      # @return [Hash]
      def index_meta(relation)
        {
          count: relation.total_count,
          pages: relation.total_pages,
          links: {
            next: next_page_path(relation),
            prev: prev_page_path(relation)
          }
        }
      end
    end
  end
end
