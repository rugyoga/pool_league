class Player < ActiveRecord::Base
  belongs_to :team
  has_many :home_games, class_name: 'Game', foreign_key: :home_player_id
  has_many :away_games, class_name: 'Game', foreign_key: :home_player_id

  def wins
    home_games.where( home_player_won: true  ) +
    away_games.where( home_player_won: false )
  end

  def no_of_wins
    wins.size
  end

  def losses
    home_games.where( home_player_won: false ) +
    away_games.where( home_player_won: true  )
  end

  def no_of_losses
    wins.size
  end

  def games
    (home_games + away_games).sort_by(&:id)
  end

  def table_runs
    wins.where( table_run: true )
  end
end
