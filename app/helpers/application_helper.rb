module ApplicationHelper
  
  def textilize(content)
    raw RedCloth.new(content).to_html
  end
  
end
