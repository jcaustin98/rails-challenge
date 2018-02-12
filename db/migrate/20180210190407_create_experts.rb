class CreateExperts < ActiveRecord::Migration[5.1]
  def change
    create_table :experts, expert_id: :uuid do |t|
      t.string :name
      t.string :website
      t.string :short_website

      t.timestamps
    end
  end
end
