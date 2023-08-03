class ApplicationController < Sinatra::Base

  # Add this line to set the Content-Type header for all responses
  set :default_content_type, 'application/json'

  get '/' do
    { message: "Hello world" }.to_json
  end

  get '/games' do 
    # --games = Game.all  # get all the gmaes from the database
    games = Game.all.order(:title).limit(10) # get all the games from the database, but display on the titles and limit it to the first 10
    games.to_json # return a JSON response with an array of all the game data
  end

  # use the :id syntax to create a dynamic route
  get '/games/:id' do
    game = Game.find(params[:id]) # look up the game in the database using its ID
    # game.to_json
    # game.to_json(include: :reviews) # include associated reviews in the JSON response
    # game.to_json(include: { reviews: { include: :user } })# to take it a level further, include the users associated with each review
    game.to_json(only: [:id, :title, :genre, :price], include: { # include associated reviews in the JSON response
      reviews: { only: [:comment, :score], include: {
        user: { only: [:name] }
      } }
    })
  end

end
