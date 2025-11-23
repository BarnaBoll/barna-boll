class UserTeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_team, only: [ :show, :edit, :update, :destroy, :add_member, :remove_member ]
  before_action :require_creator!, only: [ :edit, :update, :destroy, :add_member, :remove_member ]

  def index
    @user_teams = current_user.user_teams.includes(:creator, :members)
    @user_team  = UserTeam.new
  end

  def show
    member_ids = @user_team.members.pluck(:id)

    @upcoming_matches =
      Match
        .joins(teams: :registrations)
        .where("matches.date >= ?", Date.today)
        .where(registrations: { user_id: member_ids })
        .includes(:city, :location)
        .distinct

    @player_stats_by_user =
      if defined?(PlayerStat)
        PlayerStat.where(user_id: member_ids).includes(:city, :location).group_by(&:user)
      else
        {}
      end
  end

  def new
    @user_team = UserTeam.new
  end

  def create
    @user_team = current_user.user_teams_created.build(user_team_params)

    ActiveRecord::Base.transaction do
      if @user_team.save
        @user_team.user_team_memberships.find_or_create_by!(user: current_user)
        redirect_to @user_team, notice: "Team created."
      else
        # For now just redirect back to dashboard with errors in flash
        flash[:alert] = @user_team.errors.full_messages.to_sentence
        redirect_to authenticated_root_path, status: :unprocessable_entity
      end
    end
  end

  def edit
  end

  def update
    if @user_team.update(user_team_params)
      redirect_to @user_team, notice: "Team updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user_team.destroy
    redirect_to authenticated_root_path, notice: "Team deleted."
  end

  # POST /user_teams/:id/add_member
  def add_member
    email = params[:email].to_s.strip.downcase

    if email.blank?
      redirect_to @user_team, alert: "Please provide an email.", status: :see_other
      return
    end

    user = User.find_by("lower(email) = ?", email)

    unless user
      redirect_to @user_team, alert: "No user with that email exists.", status: :see_other
      return
    end

    if @user_team.includes?(user)
      redirect_to @user_team, alert: "That user is already on the team.", status: :see_other
      return
    end

    @user_team.user_team_memberships.create!(user: user)
    redirect_to @user_team, notice: "Member added."
  end

  # DELETE /user_teams/:id/remove_member/:user_id
  def remove_member
    user = User.find(params[:user_id])
    membership = @user_team.user_team_memberships.find_by(user: user)

    if membership.nil?
      redirect_to @user_team, alert: "Member not found in this team.", status: :see_other
      return
    end

    if user.id == @user_team.creator_id
      redirect_to @user_team, alert: "You cannot remove the creator from the team.", status: :see_other
      return
    end

    membership.destroy
    redirect_to @user_team, notice: "Member removed."
  end

  private

  def set_user_team
    @user_team = UserTeam.find(params[:id])
  end

  def require_creator!
    return if @user_team.creator?(current_user)

    redirect_to authenticated_root_path,
              alert: "You do not have permission to manage this team."
  end

  def user_team_params
    params.require(:user_team).permit(:name, :description)
  end
end
