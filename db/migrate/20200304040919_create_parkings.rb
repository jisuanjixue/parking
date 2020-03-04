class CreateParkings < ActiveRecord::Migration[6.0]
  def change
    create_table :parkings do |t|
      t.string :parking_type
      t.datetime :start_at
      t.datetime :end_at
      t.integer :amount
      t.belongs_to :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
