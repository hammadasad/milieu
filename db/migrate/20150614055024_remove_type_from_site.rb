class RemoveTypeFromSite < ActiveRecord::Migration
  def change
  	remove_column :sites, :type, :string
  	add_column :sites, :type_of_property, :string
  end
end
