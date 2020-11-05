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

app.get("/api", function (req, res) {
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
let localhost = "localhost";
const user = "root";
const password = "Quanbmt123@";
const database = "Users";

app.post("/login", jsonParse, function (req, res) {
  var connect = mysql.createConnection({
    host: localhost,
    user: user,
    password: password,
    database: database,
  });
  var sqlString = `SELECT * FROM Users WHERE user_name = '${req.body.username}' and password = '${req.body.password}'`;
  console.log(sqlString);
  // connect.connect(function (err) {
  //   if (err) throw err;
  //   connect.query(sqlString, function (error, rows) {
  //     if (rows.length == 1) {
  //       res.json(
  //         {
  //           message: "đăng nhập thành công !!",
  //         },
  //         200
  //       );
  //     } else {
  //       res.json(
  //         {
  //           message: "sai thông tin đăng nhập !!",
  //         },
  //         403
  //       );
  //     }
  //   });
  //   connect.end();
  // });
  connect.connect(function(err) {
    if (err) {
      console.error('error connecting: ' + err.stack);
      return;
    }
   
    console.log('connected as id ' + connection.threadId);
  });
});

// app.post("/register", jsonParse, function (req, res) {
//   var connect = mysql.createConnection({
//     host: localhost,
//     user: user,
//     password: password,
//     database: database,
//   });
//   var sqlString = `SELECT * FROM Users WHERE user_name = '${req.body.username}'`;
//   console.log(sqlString);
//   connect.connect(function (err) {
//     if (err) throw err;
//     connect.query(sqlString, function (error, rows) {
//       if (rows.length === 0) {
//         var sqlInsertString = `INSERT INTO Users (id, user_name,password) VALUES (1,'${req.body.username}', '${req.body.username}')`;
//         console.log(sqlInsertString);
//         connect.query(sqlInsertString, function (error, rows) {
//           console.log(error);
//           res.json(
//             {
//               message: "Đăng ký thành công!!",
//             },
//             200
//           );
//           connect.end();
//         });
//       } else {
//         res.json(
//           {
//             message: "Đăng ký thất bại !!",
//           },
//           403
//         );
//         connect.end();
//       }
//     });
//   });
// });

app.listen(port, function () {
  console.log("server is listening on port ", port);
});
