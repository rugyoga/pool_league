class FixGameFields < ActiveRecord::Migration
  def change
    rename_column :games, :home_player, :home_player_id
    rename_column :games, :away_player, :away_player_id
  end
end
