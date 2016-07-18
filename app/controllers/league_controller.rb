class LeagueController < ApplicationController
  def index
    redirect_to action: :standings
  end

  def standings
    week = params[:number].nil? ? Week.last : Week.find_by_number( params[:number] )
    @teams = Team.all.map{ |t| {id: t.id, name: t.name, match_points: t.match_points(week), games_won: t.games_won(week)}}
  end

  def generate_pairings
    Week.create_week_and_matches
    @week = Week.last
    @matches = @week.matches
  end

  def simulate_matches
    Week.last.simulate!
    redirect_to action: :week, number: Week.last.number
  end

  def match
    @match = Match.find( params[:id] )
  end

  def player
    @player = Player.find( params[:id] )
  end

  def team
    @team = Team.find( params[:id] )
  end

  def week
    @week = Week.find_by_number( params[:number] )
    @matches = @week.matches
  end
end
