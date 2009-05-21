class AddSubtitleToSite < ActiveRecord::Migration
  def self.up
    add_column :sites,:subtitle, :string, :limit=>30
  end

  def self.down
    remove_column :sites, :subtitle
  end
end
