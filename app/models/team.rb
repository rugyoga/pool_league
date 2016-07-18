class Team < ActiveRecord::Base
  belongs_to :venue
  belongs_to :league
  has_many :players
  has_many :home_matches, class_name: 'Match', foreign_key: :home_team_id
  has_many :away_matches, class_name: 'Match', foreign_key: :away_team_id

  def has_played?(t)
    home_matches.where( away_team: t ).count > 0 ||
    away_matches.where( home_team: t ).count > 0
  end

  def matches(week=Week.last)
    (home_matches + away_matches).sort_by{ |m| m.week.number }.take_while{ |m| week.nil? || m.week.number <= week.number }
  end

  def match_points(week=Week.last)
    matches(week).map{ |m| m.points_by(self) }.sum
  end

  def games_won(week=Week.last)
    matches(week).map{ |m| m.wins_by(self) }.sum
  end

  def games_lost(week=Week.last)
    matches(week).map{ |m| m.losses_by(self) }.sum
  end
end
