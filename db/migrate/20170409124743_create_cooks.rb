class CreateCooks < ActiveRecord::Migration[5.0]
  def change
    create_table :cooks do |t|
      t.string :juhe_id
      t.string :title
      t.string :tags
      t.string :imtro
      t.string :ingredients
      t.string :burden

      t.timestamps
    end
  end
end
