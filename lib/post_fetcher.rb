require 'faraday'
require 'post'

class PostFetcher

  LIMIT = 5

  def self.fetch
    response = Faraday.get('https://roon.io/api/v1/blogs/molawson/posts')

    raise(RuntimeError, 'Error contacting Roon API') unless response.success?

    raw_posts = JSON.parse(response.body)
    posts = raw_posts[0..LIMIT].map do |attributes|
      attributes.select { |k, _| Post::FIELDS.include? k.to_sym }
    end
    $redis.set('posts', posts.to_json)
  end
end
