page = Nokogiri::HTML(open('data/TeamsAndPlayers.html'))
page.css('table tr td').each do |td|
  table_count = td.css('table').count
  next unless  0 < table_count && table_count < 7
  names = td.css('font strong').map(&:text).map(&:strip)
  rosters = []
  td.css('table').each do |roster|
    players = []
    roster.css('tr').each do |player|
      tds = player.css('td')
      next unless tds.count == 6
      name = tds[0].css('a').text.strip
      next if %w(Forfeit Other).include? name
      percentage = tds[5].text.strip.to_f
      players.push({name: name, percentage: percentage})
    end
    rosters.push( players )
  end
  names.zip(rosters).each do |team_name, players|
    team = Team.create!( name: team_name )
    players.each do |player|
      Player.create!( player.merge( team_id: team.id ) )
    end
  end
end
