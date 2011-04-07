module PostsHelper

  def statusize(active)
    active ? "published" : "draft"
  end

end
