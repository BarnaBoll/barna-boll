class AddUserTeamToRegistrations < ActiveRecord::Migration[8.1]
  def change
    add_reference :registrations, :user_team, foreign_key: true, null: true
  end
end
