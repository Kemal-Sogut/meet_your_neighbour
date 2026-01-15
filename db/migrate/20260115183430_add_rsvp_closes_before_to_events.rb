class AddRsvpClosesBeforeToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :rsvp_closes_before, :integer
  end
end
