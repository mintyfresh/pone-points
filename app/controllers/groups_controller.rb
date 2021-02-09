# frozen_string_literal: true

class GroupsController < ApplicationController
  before_action :set_group, only: %i[show join leave]

  def index
    authorize(Group)
    @groups = policy_scope(Group).order(:id)
  end

  def show
    authorize(@group)
  end

  def new
    authorize(Group)
    @form = CreateGroupForm.new
  end

  def create
    authorize(Group)

    @form = CreateGroupForm.new(create_group_params)
    @form.owner = current_pone

    if (@group = @form.perform)
      redirect_to @group
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def join
    authorize(Group)

    @form = JoinGroupForm.new(group: @group, pone: current_pone)
    @form.perform

    redirect_back(fallback_location: @group)
  end

  def leave
    authorize(Group)

    @form = LeaveGroupForm.new(group: @group, pone: current_pone)
    @form.perform

    redirect_back(fallback_location: @group)
  end

private

  def set_group
    @group = Group.find_by!(slug: params[:slug])
  end

  def create_group_params
    params.require(:create_group_form).permit(:name, :description)
  end
end
