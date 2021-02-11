# frozen_string_literal: true

module Api
  module V1
    module Pones
      class PointsController < Api::BaseController
        before_action :set_pone

        def index
          authorize(Point)

          @points = policy_scope(@pone.points).order(:id).preload(:granted_by)
          @points = @points.page(params[:page]).per(params[:count])

          render json: PointBlueprint.render_as_json(@points, root: :points, meta: index_meta(@points))
        end

        def granted
          authorize(Point, :index?)

          @points = policy_scope(@pone.granted_points).order(:id).preload(:pone)
          @points = @points.page(params[:page]).per(params[:count])

          render json: PointBlueprint.render_as_json(@points, root: :points, meta: index_meta(@points))
        end

        def show
          @point = @pone.points.find(params[:id])
          authorize(@point)

          render json: PointBlueprint.render_as_json(@point, root: :point)
        end

        def give
          authorize(@pone, :give_points?)
          @form = CreatePointForm.new(give_points_params)

          if (point = @form.perform)
            render json: PointBlueprint.render_as_json(point, root: :point), status: :created
          else
            render json: { errors: @form.errors }, status: :unprocessable_entity
          end
        end

      private

        def set_pone
          @pone = Pone.find_by!(slug: params[:pone_slug])
          authorize(@pone, :show?)
        end

        def give_points_params
          params.require(:point).permit(:count, :message)
            .merge(pone: @pone, granted_by: api_key.pone)
        end

        # @param relation [ActiveRecord::Relation]
        # @return [Hash]
        def index_meta(relation)
          {
            count: relation.total_count,
            pages: relation.total_pages,
            links: {
              next:        next_page_path(relation),
              prev:        prev_page_path(relation),
              pone:        api_v1_pone_path(@pone, format: :json),
              give_points: give_api_v1_pone_points_path(@pone, format: :json)
            }
          }
        end
      end
    end
  end
end
