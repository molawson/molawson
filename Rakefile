require 'sinatra/asset_pipeline/task.rb'
require './application'

Sinatra::AssetPipeline::Task.define! MoLawson

desc 'import posts from Roon'
task :update_posts do
  require 'post_fetcher'

  puts 'Fetching posts'
  PostFetcher.fetch

  puts 'Done'
end
