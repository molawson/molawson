class Post < ActiveRecord::Base

  validates_presence_of :title, :content
  validates_uniqueness_of :title

  def self.published
    where("is_active = ?", true)
  end
end
