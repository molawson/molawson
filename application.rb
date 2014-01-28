require_relative './environment'

require 'sinatra/base'
require 'sinatra/content_for'
require 'sinatra/asset_pipeline'

require 'post'

class MoLawson < Sinatra::Base
  helpers Sinatra::ContentFor

  set :assets_precompile, %w(application.css *.png *.jpg *.svg *.eot *.ttf *.woff)
  set :assets_css_compressor, :sass
  register Sinatra::AssetPipeline

  get '/' do
    @posts = Post.all
    erb :home
  end
end
