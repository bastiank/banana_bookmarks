class Bookmark < ActiveRecord::Base
  belongs_to :user
  attr_accessible :url

  validates_presence_of :user_id
end
