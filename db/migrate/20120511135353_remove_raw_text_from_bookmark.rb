class RemoveRawTextFromBookmark < ActiveRecord::Migration
  def up
    remove_column(:bookmarks, :raw_text)
    remove_column(:bookmarks, :content_text)
  end

  def down
    add_column(:bookmarks, :raw_text, :text)
    add_column(:bookmarks, :content_text, :text)
  end
end
