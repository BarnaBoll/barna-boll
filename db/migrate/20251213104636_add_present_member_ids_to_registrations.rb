class AddPresentMemberIdsToRegistrations < ActiveRecord::Migration[8.1]
  def change
    add_column :registrations, :present_member_ids, :jsonb, default: [], null: false
  end
end
