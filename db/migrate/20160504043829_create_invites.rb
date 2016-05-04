class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :event_id
      t.string :name
      t.string :email
      t.boolean :sent, default: false

      t.timestamps
    end
  end
end
