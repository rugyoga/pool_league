class RenameMatchColumns < ActiveRecord::Migration
  def change
    rename_column :teams, :matches_won, :match_points
  end
end
