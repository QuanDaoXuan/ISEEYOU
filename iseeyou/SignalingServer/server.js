"use strict";

let WebSocketServer = require("ws").Server;
let port = 8080;
let wsServer = new WebSocketServer({ port: port });
const ip = require("ip");
console.log(
  "websocket server start." + " ipaddress = " + ip.address() + " port = " + port
);
var sockets = {};

wsServer.on("connection", function (ws, request) {
  //   console.log("connection", request.url);
  //   if (request.url && request.url != "") {
  //     let id = request.url.substring(1, request.url.length);
  //     sockets[id] = ws;
  ws.on("message", function (message) {
    //   const json = JSON.parse(message.toString());
    //   let friendId = json["friendId"];
    //   if (friendId && friendId !== "") {
    //     let socketFriend = sockets[friendId];
    //     if (socketFriend) {
    //       json["friendId"] = id;
    //       socketFriend.send(JSON.stringify(json));
    //       console.log(friendId, "to ", id);
    //     }
    //   }
    wsServer.clients.forEach(function (client) {
      if (ws != client) {
        client.send(message);
        console.log("send");
      }
    });
  });
  //   }
});

// wsServer.clients.forEach(function (client) {
//   if (ws != client) {
//     client.send(message);
//     console.log("send");
//   }
// });
