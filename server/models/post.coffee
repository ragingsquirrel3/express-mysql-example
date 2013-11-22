module.exports = (db, cb) ->
  db.define 'post',
    title: String
    content: String
    rating: Number
  
  cb()
