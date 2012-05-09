class AddContentTextToBookmark < ActiveRecord::Migration
  def change
    add_column :bookmarks, :content_text, :text
  end
end
