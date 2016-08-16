class AddPositionToParticipant < ActiveRecord::Migration
  def change
    add_column :participants, :position, :integer
  end
end
