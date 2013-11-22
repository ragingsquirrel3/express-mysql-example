orm = require 'orm'
bcrypt = require 'bcrypt'
SALT_WORK_FACTOR = 10

module.exports = (db, cb) ->
  db.define( 'user', {
    username: String
    password: String
  },
  {
    validations:
      # unique and required
      username: [orm.enforce.unique('Username already exists.'), orm.enforce.notEmptyString('Username is required.'), orm.enforce.required('Username is required.')]
      # required
      password: [orm.enforce.notEmptyString('Username is required.'), orm.enforce.required('Username is required.')]
    methods:
      comparePassword: (candidatePassword, cb) ->
        bcrypt.compare candidatePassword, @password, (err, isMatch) ->
          if err then return cb err
          cb null, isMatch

      saveAndEncryptPassword: (cb) ->
        bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) =>
          bcrypt.hash @password, salt, (err, hash) =>
            @password = hash
            @save (err) ->
              cb err
  })
  
  cb()


# # mongo v  

# UserSchema = new Schema
#   username:
#     type: String
#     required: true
#     index: { unique: true }
#   password:
#     type: String
#     required: true

# UserSchema.pre 'save', (next) ->
#   user = @

#   if !user.isModified('password') then next()

#   bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
#     bcrypt.hash user.password, salt, (err, hash) ->
#       if err then next err
#       # override the cleartext password with hashed password
#       user.password = hash
#       next()

# UserSchema.methods.comparePassword = (candidatePassword, cb) ->
#   bcrypt.compare candidatePassword, @password, (err, isMatch) ->
#     if err then return cb err
#     cb null, isMatch

# module.exports = mongoose.model 'User', UserSchema
