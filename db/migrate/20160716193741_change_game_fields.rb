class ChangeGameFields < ActiveRecord::Migration
  def change
    rename_column(:games, :player1, :home_player)
    rename_column(:games, :player2, :away_player)
    rename_column(:games, :player1_won, :home_player_won)
    add_column(:games, :home_player_broke, :boolean)
  end
end
