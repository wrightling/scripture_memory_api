class AddTranslationToCards < ActiveRecord::Migration
  def change
    add_column :cards, :translation, :string
  end
end
