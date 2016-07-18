class Week < ActiveRecord::Base
  belongs_to :league
  has_many :matches, dependent: :destroy

  def self.generate_matches
    has_played = Hash.new { |h1,k1| Hash.new { |h2,k2| false } }
    Match.all.each do |m|
      has_played[m.home_team][m.away_team] = true
      has_played[m.away_team][m.home_team] = true
    end
    by_match_points = Team.all.sort_by{|t| [t.match_points,t.games_won,t.strength] }.chunk_while{ |t1,t2| t1.match_points == t2.match_points }.to_a
    pairings = []
    until by_match_points.empty?
      played_everyone = []
      group = by_match_points.pop
      by_match_points.last.push(group.shift) if group.length.odd?
      next if group.empty?
      half = group.length / 2
      bottom_half = group.take(half)
      top_half = group.drop(half)
      until bottom_half.empty? || top_half.empty?
        top_seed = top_half.pop
        opponent = bottom_half.find_all{ |c| !has_played[c][top_seed] }.last
        unless opponent.nil?
          bottom_half.delete(opponent)
          pairings << [top_seed, opponent]
        else
          opponent = top_half.find_all{ |c| !has_played[c][top_seed] }.first
          unless opponent.nil?
            top_half.delete(opponent)
            pairings << [top_seed, opponent]
          else
            played_everyone.unshift(top_seed)
          end
        end
      end
      leftovers = bottom_half + top_half + played_everyone
      next if leftovers.empty?
      unless by_match_points.empty?
        by_match_points.last.concat(leftovers)
      else
        by_match_points.push(leftovers)
      end
    end
    pairings
  end

  def self.pick_venue(tables, t, b)
    if tables[t.venue] > 0
      if tables[b.venue] > 0
        if t.away_matches.size != t.home_matches.size
          t.away_matches.size > t.home_matches.size ? t : b
        elsif b.away_matches.size != b.home_matches.size
          b.away_matches.size > b.home_matches.size ? b : t
        else
          [b,t].sample
        end
      else
        t
      end
    elsif tables[b.venue] > 0
      b
    end
  end

  def self.assign_venues(pairings)
    tables = Hash[Venue.all.map{|v| [v, v.tables] }]
    without_venues = []
    with_venues = []
    pairings.each do |t, b|
      v = pick_venue(tables, t, b)
      unless v.nil?
        tables[v.venue] -= 1
        with_venues.push( [t,b,v.venue] )
      else
        without_venues.push([t,b])
      end
    end
    tables = tables.to_a.map{ |v,c| [v] * c }.flatten.shuffle
    [without_venues.size,
     with_venues.concat(
       without_venues.map{ |t, b| [t,b,tables.pop] }
     )]
  end

  def self.best_pairing(tries=100)
    matches = generate_matches
    best_i = matches.size
    best_pairs = nil
    tries.times do |n|
      i, pairs = Week.assign_venues(matches)
      return [0,pairs] if i == 0
      if i < best_i
        best_i = i
        best_pairs = pairs
      end
    end
    [best_i, best_pairs]
  end

  def self.create_week_and_matches
    league = League.last
    Week.transaction do
      last_week = Week.all.map(&:number).push(0).max
      this_week = Week.create!( league: league, number: last_week+1 )
      best_pairing[1].each do |t, b, v|
        t_home = { home_team: t, away_team: b, venue: v, week: this_week }
        b_home = { home_team: b, away_team: t, venue: v, week: this_week }
        m = t.venue == v ? t_home : (b.venue == v ? b_home : [t_home, b_home].sample)
        Match.create!( m )
      end
    end
  end

  def simulate!
    matches.each{ |match| match.simulate! }
  end

  def self.show_pairing
    best_i, best_pairs = best_pairing
    puts best_pairs.map{ |a,b,v| "@#{v.name}: #{a.name} vs #{b.name}" }.join("\n")
    puts "#{best_i} leftovers\n\n"
  end
end
