class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.integer :event_id
      t.string :name
      t.string :title
      t.string :division
      t.text :biography

      t.timestamps
    end
  end
end
