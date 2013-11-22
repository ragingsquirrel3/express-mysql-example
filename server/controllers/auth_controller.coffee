passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
User = require '../models/user'
authController = {}

# Configure passport.
passport.use new LocalStrategy { passReqToCallback: true }, (req, username, password, done) ->
  req.models.user.find { username: username }, (err, users) ->
    if err then return done(err, false, { message: 'An error occurred.' })
    user = users?[0]
    unless user then return done(err, false, { message: 'Username not found.' })
    user.comparePassword password, (err, isMatch) ->
      if isMatch
        done null, user
      else
        done null, false, { message: 'Invalid Password' }

passport.serializeUser (user, done) ->
  done null, user

passport.deserializeUser (user, done) ->
  done null, user

authController.newRegistration = (req, res) ->
  res.render 'public/signup'

authController.createRegistration = (req, res) ->
  user = new req.models.user
    username: req.body.username
    password: req.body.password
  user.saveAndEncryptPassword (err) ->
    if err
      res.send 400, err
    else
      req.login user, (err) ->
        res.redirect '/'

authController.destroySession = (req, res) ->
  req.logOut()
  res.redirect '/login'

authController.newSession = (req, res) ->
  res.render 'public/login'

authController.createSession = passport.authenticate 'local',
  successRedirect: '/'
  failureRedirect: '/login'

module.exports = authController
