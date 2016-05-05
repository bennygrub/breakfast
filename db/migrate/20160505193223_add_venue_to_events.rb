class AddVenueToEvents < ActiveRecord::Migration
  def change
    add_column :events, :venue, :text
  end
end
