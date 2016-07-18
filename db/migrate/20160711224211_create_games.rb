class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :player1
      t.integer :player2
      t.boolean :player1_won
      t.boolean :table_run
      t.integer :match_id
      t.integer :game_number
      t.timestamps null: false
    end
  end
end
