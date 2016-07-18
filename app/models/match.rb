class Match < ActiveRecord::Base
  has_many :games, dependent: :destroy
  belongs_to :week
  belongs_to :venue
  belongs_to :home_team, class_name: 'Team'
  belongs_to :away_team, class_name: 'Team'

  GAMES=[
    { home: 0, away: 0, home_breaks: false},
    { home: 1, away: 1, home_breaks: true },
    { home: 2, away: 2, home_breaks: false},
    { home: 3, away: 3, home_breaks: true },
    { home: 1, away: 0, home_breaks: true },
    { home: 0, away: 1, home_breaks: true },
    { home: 2, away: 3, home_breaks: true },
    { home: 1, away: 2, home_breaks: false},
    { home: 3, away: 1, home_breaks: false},
    { home: 0, away: 3, home_breaks: false},
    { home: 2, away: 0, home_breaks: true },
    { home: 3, away: 2, home_breaks: true },
    { home: 1, away: 3, home_breaks: false},
    { home: 2, away: 1, home_breaks: false},
    { home: 0, away: 2, home_breaks: true },
    { home: 3, away: 0, home_breaks: false}]

  def simulate!
    home = home_team.players.sample(4)
    away = away_team.players.sample(4)
    Match.transaction do
      GAMES.each_with_index do |g, n|
        game = Game.create!( home_player: home[g[:home]], away_player: away[g[:away]], home_player_broke: g[:home_breaks], game_number: n, match: self )
        game.simulate!
      end
    end
  end

  def home_wins
    games.where( home_player_won: true ).size
  end

  def away_wins
    games.where( home_player_won: false ).size
  end

  def wins_by(t)
    t == home_team ? home_wins : away_wins
  end

  def losses_by(t)
    t == home_team ? away_wins : home_wins
  end

  def points_by(t)
    w, l = wins_by(t), losses_by(t)
    w > l ? 2 : (l > w ? 0 : 1)
  end
end
