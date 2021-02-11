# frozen_string_literal: true

module Api
  module V1
    class GroupsController < Api::BaseController
      before_action :set_group, only: %i[show members]

      def index
        authorize(Group)

        @groups = policy_scope(Group).order(:id).preload(:owner)
        @groups = @groups.page(params[:page]).per(params[:count])

        render json: GroupBlueprint.render_as_json(@groups, root: :groups, meta: index_meta(@groups))
      end

      def show
        authorize(@group)

        render json: GroupBlueprint.render_as_json(@group, root: :group, view: :detail)
      end

      def members
        authorize(@group, :show?) && authorize(Pone, :index?)
        @members = policy_scope(@group.members).order(:id).preload(avatar_attachment: :blob)

        render json: PoneBlueprint.render_as_json(@members, root: :members)
      end

    private

      def set_group
        @group = Group.find_by!(slug: params[:slug])
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
