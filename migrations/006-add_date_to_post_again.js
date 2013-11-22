mysql = require('mysql');


exports.up = function(next){
  var connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'root',
    database: 'mysqltest'
  });

  connection.connect();

  connection.query('ALTER TABLE post ADD COLUMN rating INTEGER', function (err) {
    if (err) {console.log(err);}
    next();
  });

};

exports.down = function(next){
  next();
};
