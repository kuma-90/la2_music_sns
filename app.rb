require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'
require './models'
require 'dotenv/load'
require 'open-uri'
require 'json'
require 'net/http'

enable :sessions

before do
    Dotenv.load
    Cloudinary.config do |config|
        config.cloud_name = ENV['CLOUD_NAME']
        config.api_key = ENV['CLOUDNARY_API_KEY']
        config.api_secret = ENV['CLOUDNARY_API_SECRET']
    end
end

helpers do
    def current_user
      User.find_by(id: session[:user])
    end
end

get '/' do
     @postos = Contribution.all
    erb :index
end

post '/' do
 @content = Contribution.find(params[:id])
  content = Contribution.find(params[:id])
 end


get '/signin' do
    erb :sign_in
end

post '/signin' do
    user = User.find_by(name: params[:name])
    if user && user.authenticate(params[:password])
        session[:user] = user.id
    end
    
redirect '/'
end

get '/signup' do
    erb :sign_up
end

post '/signup' do
     img_url =''
    if params[:file]
        img = params[:file]
        tempfile = img[:tempfile]
        upload = Cloudinary::Uploader.upload(tempfile.path)
        img_url = upload['url']
    end
     user = User.create(
        name: params[:name], 
        password: params[:password],
        password_confirmation: params[:password_confirmation],
         img: img_url
    )
    if user.persisted?
        session[:user] = user.id
    end
    redirect '/'
end

get '/signout' do
    session[:user] = nil
    redirect '/'
end

get '/search' do
    keyword = params[:keyword]
    uri = URI("https://itunes.apple.com/search")
    uri.query = URI.encode_www_form({term: keyword, country: "JP", media: "music",limit: "10"})
    res = Net::HTTP.get_response(uri)
    returned_JSON = JSON.parse(res.body)
    @musics = returned_JSON["results"]
    
    erb :search
end


post '/new' do
    puts params[:artworkUrl100]
    Contribution.create(
    jacket: params[:artworkUrl100],
   song: params[:trackName],
   album: params[:collectionName],
   artist_name: params[:artistName],
   url: params[:previewUrl],
   user_name: params[:user_name],
   comments: params[:comment],
   id: params[:id]
    )
  redirect '/home'
end

get '/home' do
     @postos = Contribution.all
   
     erb :home
 end


post 'home/:id' do
 @content = Contribution.find(params[:id])
 end


    
post '/delete/:id' do
   
    @content = Contribution.find(params[:id])
     Contribution.find(params[:id]).destroy
     redirect '/home'
end

get '/edit/:id' do
    @postos = Contribution.all
    @content = Contribution.find(params[:id])
    erb :edit
end

get 'renew' do
    @postos = Contribution.all
end

post 'renew/:id' do
    content = Contribution.find(params[:id])
    content.update({
        comments: params[:comment]
    })
redirect '/home'
end

