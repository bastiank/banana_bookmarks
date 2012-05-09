class AddPageDumpToBookmark < ActiveRecord::Migration
  def change
    add_column :bookmarks, :page_dump, :text, :limit => 4294967295
  end
end
