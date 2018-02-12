class CreateTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :topics do |t|
      t.string :tag
      t.text :text
      t.integer :expert_id

      t.timestamps
    end
  end
end
