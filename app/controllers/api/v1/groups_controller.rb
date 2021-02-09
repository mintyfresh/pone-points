# frozen_string_literal: true

module Api
  module V1
    class GroupsController < ApplicationController
      before_action :set_group, only: %i[show members]

      def index
        authorize(Group)
        @groups = policy_scope(Group).order(:id)

        render json: GroupBlueprint.render_as_json(@groups, root: :groups)
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
    end
  end
end
