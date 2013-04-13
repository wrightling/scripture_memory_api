class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :subject
      t.text :scripture
      t.string :reference

      t.timestamps
    end
  end
end
