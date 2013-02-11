require 'pry'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'active_support/all'
require 'pg'


before do
  sql = "SELECT DISTINCT genre FROM videos;"
  @nav_rows = run_sql(sql)
end

get '/' do
erb :home
end


get '/new' do
 erb :new
end

post '/create' do
  sql = "INSERT INTO videos (title, description, video, genre) VALUES ('#{params['title']}', '#{params['description']}', '#{params['video']}', '#{params['genre']}');"
  run_sql(sql)
  redirect to('/videos')
end



post '/videos/:videos_id' do
  sql = "UPDATE videos SET title = '#{params[:title]}', description = '#{params[:description]}', video = '#{params[:video]}', genre = '#{params[:genre]}' WHERE id = '#{params['videos_id']}';"
  run_sql(sql)
  redirect to ('/videos')
end



get '/videos/:genre' do
  sql = "SELECT * FROM videos WHERE genre = '#{params['genre']}';"
  @rows = run_sql(sql)
  erb :videos
end

get '/videos/:videos_id/edit' do
  sql = "SELECT * from videos where id = #{params['videos_id']}"
  rows = run_sql(sql)
  @row = rows.first
  erb :new
end

post '/videos/:videos_id/delete' do
  sql = "DELETE FROM videos WHERE id = #{params['videos_id']};"
  run_sql(sql)
  redirect to('/videos')
end

get '/videos' do
  sql = "SELECT * FROM videos"
  @rows = run_sql(sql)
  erb :videos
end


def run_sql(sql)
  conn = PG.connect(:dbname =>'videosdb', :host => 'localhost')
  result = conn.exec(sql)
  conn.close
  result
end