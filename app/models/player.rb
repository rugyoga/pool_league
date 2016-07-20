class Player < ActiveRecord::Base
  belongs_to :team
  has_many :home_games, class_name: 'Game', foreign_key: :home_player_id
  has_many :away_games, class_name: 'Game', foreign_key: :away_player_id

  def wins
    @wins ||= home_games.where( home_player_won: true  ) +
              away_games.where( home_player_won: false )
  end

  def no_of_wins
    wins.size
  end

  def losses
    @losses ||= home_games.where( home_player_won: false ) +
                away_games.where( home_player_won: true  )
  end

  def no_of_losses
    losses.size
  end

  def win_percentage
    games.size == 0 ? 0.0 : (100.0*no_of_wins.to_f)/no_of_games.to_f
  end

  def games
    @games ||= (home_games + away_games).sort_by(&:id)
  end

  def no_of_games
    games.size
  end

  def table_runs
    @table_runs ||= wins.select(&:table_run)
  end

  def no_of_table_runs
    table_runs.size
  end
end
