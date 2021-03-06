// mysql> CREATE USER 'matomo'@'localhost' IDENTIFIED BY 'my-strong-password-here';
//create user and password for my database.

var express = require("express");
var bodyParser = require("body-parser");
var app = express();

var port = 3000;
var jsonParse = bodyParser.json();
var urlencodedParser = bodyParser.urlencoded({ extended: false });
var mysql = require("mysql");
const { delay } = require("lodash");

app.set("view engine", "ejs");

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
              user: rows[0],
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
            var sqlInsertString = `INSERT INTO Users (username,password,token,name,sdt,imageLink,address) VALUES ('${req.body.username}', '${req.body.password}','${req.body.token}','${req.body.name}','${req.body.sdt}','${req.body.imageLink}','${req.body.address}')`;
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

app.post("/auth_me", jsonParse, function (req, res) {
  console.log("req.body.idUsers");
  var connection = mysql.createConnection({
    host: localhost,
    user: user,
    password: password,
    database: database,
  });
  console.log("req.body.idUsers", req.body.idUsers);
  var sqlString = `SELECT * FROM Users WHERE idUsers = ${req.body.idUsers}`;
  console.log(sqlString);
  connection.connect(function (err) {
    if (err) throw err;
    if (req.body.idUsers == "") {
      res.status(400).send({ error: "idUser is undefined" });
      console.log("idUser is undefined");
    } else {
      connection.query(sqlString, function (error, rows) {
        if (error) {
          console.log("error when query: ", error);
        } else {
          if (rows.length == 1) {
            console.log(rows);
            res.json(
              {
                user: rows[0],
              },
              200
            );
          } else {
            res.status(400).send({ error: "Bad Request" });
            console.log("Bad Request");
          }
        }
      });
    }
    connection.end();
  });
});

app.get("/get_list_users/", jsonParse, function (req, res) {
  var connection = mysql.createConnection({
    host: localhost,
    user: user,
    password: password,
    database: database,
  });
  var sqlString = `SELECT * FROM Users`;
  console.log(sqlString);
  connection.connect(function (err) {
    if (err) throw err;

    connection.query(sqlString, function (error, rows) {
      if (error) {
        console.log("error when query: ", error);
        res.status(405).send({ error: "server Errror" });
      } else {
        res.json(
          {
            users: rows,
          },
          200
        );
      }
    });

    connection.end();
  });
});

app.get("/fetchCard", jsonParse, function (req, res) {
  // delay(2);
  setTimeout(function () {
    res.json({
      items: [
        {
          id: 4,
          name: "",
          company_name: "company23422_name",
          created_at: "2020-11-11T09:02:53.000000Z",
          image_url: null,
          card_user_id: 5,
          displayed_started_at: "2020/11/11",
        },
        {
          id: 4,
          name: "",
          company_name: "company23422_name",
          created_at: "2020-11-11T09:02:53.000000Z",
          image_url: null,
          card_user_id: 5,
          displayed_started_at: "2020/11/11",
        },
        {
          id: 4,
          name: "",
          company_name: "company23422_name",
          created_at: "2020-11-11T09:02:53.000000Z",
          image_url: null,
          card_user_id: 5,
          displayed_started_at: "2020/11/11",
        },
        {
          id: 4,
          name: "",
          company_name: "company23422_name",
          created_at: "2020-11-11T09:02:53.000000Z",
          image_url: null,
          card_user_id: 5,
          displayed_started_at: "2020/11/11",
        },
        {
          id: 4,
          name: "",
          company_name: "company23422_name",
          created_at: "2020-11-11T09:02:53.000000Z",
          image_url: null,
          card_user_id: 5,
          displayed_started_at: "2020/11/11",
        },
        {
          id: 4,
          name: "",
          company_name: "company23422_name",
          created_at: "2020-11-11T09:02:53.000000Z",
          image_url: null,
          card_user_id: 5,
          displayed_started_at: "2020/11/11",
        },
        {
          id: 4,
          name: "",
          company_name: "company23422_name",
          created_at: "2020-11-11T09:02:53.000000Z",
          image_url: null,
          card_user_id: 5,
          displayed_started_at: "2020/11/11",
        },
        {
          id: 4,
          name: "",
          company_name: "company23422_name",
          created_at: "2020-11-11T09:02:53.000000Z",
          image_url: null,
          card_user_id: 5,
          displayed_started_at: "2020/11/11",
        },
      ],
      pagination: {
        page: 1,
        limit: 50,
        sort_by: "created_at",
        sort_type: "desc",
        number: 0,
        total: 0,
        last_id: 0,
      },
    });
  }, 2000);
});

app.listen(port, function () {
  console.log("server is listening on port ", port);
});
