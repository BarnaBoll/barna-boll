class CreateUserTeamMemberships < ActiveRecord::Migration[8.1]
  def change
    create_table :user_team_memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :user_team, null: false, foreign_key: true

      t.timestamps
    end

    add_index :user_team_memberships, [ :user_id, :user_team_id ], unique: true
  end
end
