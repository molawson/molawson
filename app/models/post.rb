class Post < ActiveRecord::Base

  validates_presence_of :title, :content
  validates_uniqueness_of :title, :slug
  
  before_save :update_slug

  def self.published
    where("is_active = ?", true)
  end
  
  private #-----------------------
  
  def update_slug
    self.slug = self.title.downcase.gsub(/\s/ , '-').gsub(/[^a-zA-Z0-9-]+/,'')
  end
end
