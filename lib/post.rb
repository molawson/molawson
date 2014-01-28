class Post

  FIELDS = %i(id title excerpt_html published_at updated_at read_time url)

  attr_reader *FIELDS

  def initialize(attributes = {})
    FIELDS.each do |field|
      next unless attributes.has_key? field.to_s

      send("#{field}=", attributes[field.to_s])
    end
  end

  def self.all
    json = $redis.get('posts') || [].to_json
    JSON.parse(json).map { |attributes| Post.new attributes }
  end

  private

  attr_writer *FIELDS

end
