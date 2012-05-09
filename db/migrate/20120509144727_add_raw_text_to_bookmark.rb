class AddRawTextToBookmark < ActiveRecord::Migration
  def change
    add_column :bookmarks, :raw_text, :text
  end
end
