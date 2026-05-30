class RegistrationsController < ApplicationController
  before_action :authenticate_user!

  def create
    match = Match.find(params[:match_id])

    # Delegate to the service object
    result = MatchRegistrationService.new(match, current_user, params).call

    if result[:success]
      redirect_to schedule_path, notice: result[:message]
    else
      redirect_back fallback_location: schedule_path,
                    alert: result[:error],
                    status: :see_other
    end
  end
end
