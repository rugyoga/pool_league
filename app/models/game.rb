class Game < ActiveRecord::Base
  belongs_to :match
  belongs_to :home_player, class_name: 'Player'
  belongs_to :away_player, class_name: 'Player'

  def simulate!
    hp = home_player.percentage
    ap = away_player.percentage
    update_attribute( :home_player_won, Random.rand <= hp/(hp+ap) )
  end

  def opponent(p)
    home_player == p ? away_player : home_player
  end

  def won?(p)
    home_player == p && home_player_won || away_player == p && !home_player_won
  end

  def lost?(p)
    !won?(p)
  end
end
