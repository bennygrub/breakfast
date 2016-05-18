class AddFocusAreaToEvents < ActiveRecord::Migration
  def change
    add_column :events, :focus_area, :text
  end
end
