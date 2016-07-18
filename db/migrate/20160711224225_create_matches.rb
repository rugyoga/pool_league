class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :venue_id
      t.integer :home_team_id
      t.integer :away_team_id
      t.integer :week_id
      t.date :played_on
      t.timestamps null: false
    end
  end
end
