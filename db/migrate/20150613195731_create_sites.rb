class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :address
      t.float :latitude
      t.float :longitude
      t.text :description
      t.string :contact_info
      t.string :status

      t.timestamps null: false
    end
  end
end
