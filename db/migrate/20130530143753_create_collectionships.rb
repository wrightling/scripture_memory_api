class CreateCollectionships < ActiveRecord::Migration
  def change
    create_table :collectionships do |t|
      t.integer :card_id
      t.integer :collection_id

      t.timestamps
    end
  end
end
