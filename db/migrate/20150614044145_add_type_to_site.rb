class AddTypeToSite < ActiveRecord::Migration
  def change
    add_column :sites, :type, :string
  end
end
