class RemoveStatsFromTeams < ActiveRecord::Migration
  def change
    remove_column :teams, :games_lost
    remove_column :teams, :games_won
    remove_column :teams, :match_points
    remove_column :teams, :matches_lost
    remove_column :teams, :matches_away
    remove_column :teams, :matches_home
  end
end
