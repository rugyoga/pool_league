class AddTeamStrength < ActiveRecord::Migration
  def up
    add_column :teams, :strength, :float
    Team.reset_column_information
    Team.all.each do |team|
      team.strength = team.players.map(&:percentage).sort.reverse.take(4).sum/4.0
      team.save!
    end
  end

  def down
    remove_column :teams, :strength
  end
end
