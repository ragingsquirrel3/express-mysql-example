express = require 'express'
passport = require 'passport'
orm = require 'orm'

ASSET_BUILD_PATH = 'server/client_build/development'
PORT = process.env.PORT ? 3000
SESSION_SECRET = process.env.SESSION_SECRET ? 'keyboard kitty'
WHITELISTED_URLS = ['/login', '/signup']

# db
db = require './server/db'

# controllers
publicController = require './server/controllers/public_controller'
authController = require './server/controllers/auth_controller'

# login unless route in WHITELISTED_URLS
ensureAuthenticated = (req, res, next) ->
  return res.redirect '/login' unless req.user || req.url in WHITELISTED_URLS
  next()

app = express()
app.use db

app.configure ->
  # jade templates from templates dir
  app.use express.compress()
  app.set 'views', "#{__dirname}/server/templates"
  app.set 'view engine', 'jade'
  #
  # serve static assets
  app.use('/assets', express.static("#{__dirname}/#{ASSET_BUILD_PATH}"))
  
  # needed for body parsing and session usage
  app.use express.cookieParser()
  app.use express.bodyParser()
  app.use express.session secret: SESSION_SECRET
  app.use passport.initialize()
  app.use passport.session()
  # assigin login rules after assigning static route
  app.use ensureAuthenticated
  
  # logging
  # app.use express.logger()
  
# public routes
app.get '/', publicController.index

app.get '/posts', (req, res) ->
  req.models.post.find {}, (err, posts) ->
    console.log err, posts
    res.send posts

app.get '/users', (req, res) ->
  req.models.user.find {}, (err, users) ->
    res.send users

# app.post '/posts', (req, res) ->
#   post = new req.models.post { title: 'foo', content: 'bar'}
#   post.save (err) -> 
#     res.send post

# auth routes
app.get '/signup', authController.newRegistration
app.post '/signup', authController.createRegistration
app.get '/login', authController.newSession
app.post '/login', authController.createSession
app.get '/logout', authController.destroySession

# TEMP
module.exports = app
# app.listen 3000
