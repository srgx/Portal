require 'bundler/setup'
require 'sinatra'
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")

class Post
    include DataMapper::Resource
    property :id, Serial
    property :title, String
    property :body, Text
    property :created_at, DateTime
end

DataMapper.finalize
Post.auto_upgrade!

get '/' do
  erb :index
end

get '/posts' do
  @posts = Post.all(:order => [ :id.desc ], :limit => 20)
  erb :posts
end

get '/posts/new' do
  erb :posts_new
end

get '/posts/:id' do
  @post = Post.get(params[:id])
  erb :posts_show
end

get '/posts/:id/edit' do
  @post = Post.get(params[:id])
  erb :posts_edit
end

post '/posts' do
  Post.create(
    :title      => params[:title],
    :body       => params[:body],
    :created_at => Time.now
  )
  redirect '/posts'
end

post '/posts/:id' do
  post = Post.get(params[:id])
  post.update(title:params[:title],body:params[:body])
  redirect '/posts'
end
