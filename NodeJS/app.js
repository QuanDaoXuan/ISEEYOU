// mysql> CREATE USER 'matomo'@'localhost' IDENTIFIED BY 'my-strong-password-here';
//create user and password for my database.

var express = require("express");
var bodyParser = require("body-parser");
var app = express();

var port = 3000;
var jsonParse = bodyParser.json();
var urlencodedParser = bodyParser.urlencoded({ extended: false });
var mysql = require("mysql");

app.set("view engine", "ejs");

app.get("/auth_me", function (req, res) {
  res.json({
    quan: 123,
  });
});

// CREATE USER 'me'@'localhost' IDENTIFIED BY 'Aa12345678@'
// CREATE TABLE Users (
//   id int,
//   username varchar(255),
//   password varchar(255)
// );
//info access database
//login mysql -u root -p
let localhost = "127.0.0.1";
const user = "root";
const password = "Quanbmt123@";
const database = "iseeyou";

app.post("/login", jsonParse, function (req, res) {
  var connection = mysql.createConnection({
    host: localhost,
    user: user,
    password: password,
    database: database,
  });

  var sqlString = `SELECT * FROM Users WHERE username = '${req.body.username}' and password = '${req.body.password}'`;
  console.log(sqlString);
  connection.connect(function (err) {
    if (err) throw err;
    connection.query(sqlString, function (error, rows) {
      if (error) {
        console.log("error when query: ", error);
      } else {
        if (rows.length == 1) {
          console.log(rows);
          res.json(
            {
              message: "đăng nhập thành công !!",
            },
            200
          );
        } else {
          res.status(400).send({ error: "Bad login" });
          console.log("400 bad login");
        }
      }
    });
    connection.end();
  });
});

app.post("/register", jsonParse, function (req, res) {
  var connection = mysql.createConnection({
    host: localhost,
    user: user,
    password: password,
    database: database,
  });
  var sqlString = `SELECT * FROM Users WHERE username = '${req.body.username}'`;
  console.log(sqlString);
  connection.connect(function (err) {
    if (err) throw err;
    connection.query(sqlString, function (error, rows) {
      if (error) {
        console.log(error);
        res.status(400).send({
          message: "Có lỗi xảy ra.",
        });
        connection.end();
      } else {
        if (rows.length === 0) {
          if (req.body.username == "" || req.body.password == "") {
            console.log("code 400");
            res.status(400).send({
              message: "Vui lòng điền đầy đủ username và password",
            });
          } else {
            var sqlInsertString = `INSERT INTO Users (username,password) VALUES ('${req.body.username}', '${req.body.password}')`;
            console.log(sqlInsertString);
            connection.query(sqlInsertString, function (error, rows) {
              if (error) {
                console.log(error);
                res.status(400).send({
                  message: "Không thể đăng ký user mới!!",
                });
              } else {
                res.json(
                  {
                    message: "Đăng ký thành công!!",
                  },
                  200
                );
                connection.end();
              }
            });
          }
        } else {
          res.status(400).send({
            message: "Có lỗi xảy ra, đăng ký thất bại. !!",
          });
          connection.end();
        }
      }
    });
  });
});

app.listen(port, function () {
  console.log("server is listening on port ", port);
});
