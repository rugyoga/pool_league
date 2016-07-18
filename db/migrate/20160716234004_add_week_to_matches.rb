class AddWeekToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :week_id, :integer
  end
end
