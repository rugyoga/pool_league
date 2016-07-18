class AddVariousFieldsToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :matches_won,  :integer, default: 0
    add_column :teams, :matches_lost, :integer, default: 0
    add_column :teams, :matches_away, :integer, default: 0
    add_column :teams, :matches_home, :integer, default: 0
    add_column :teams, :games_won,    :integer, default: 0
    add_column :teams, :games_lost,   :integer, default: 0
  end
end
