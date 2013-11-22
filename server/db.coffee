orm = require 'orm'

# connect mysql db, load models
# In other models (i.e. controllers), models can be accessed with req.models.modelName.
module.exports = orm.express 'mysql://root@localhost/mysqltest',
  define: (db, models, next) ->

    db.load './models/post', (err) ->
      models.post = db.models.post
      db.load './models/user', (err) ->
        models.user = db.models.user

        # Adds new tables to schema if they don't exist; doesn't alter existing.
        db.sync ->
          next()
