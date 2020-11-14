
"use strict";

let WebSocketServer = require('ws').Server;
let port = 8080;
let wsServer = new WebSocketServer({ port: port });
const ip = require('ip');
console.log('websocket server start.' + ' ipaddress = ' + ip.address() + ' port = ' + port);
var sockets = {}

wsServer.on('connection', function (ws, request) {
    console.log("connection", request.url)
    if (request.url && request.url != "") {
        let id = request.url.substring(1, request.url.length)
        sockets[id] = ws

        ws.on('message', function (message) {
            const json = JSON.parse(message.toString());
            let friendId = json["sessionDescription"]["friendId"]

            if (friendId && friendId !== "") {
                let socketFriend = sockets[friendId]
                if (socketFriend) {
                    json["sessionDescription"]["friendId"] = id
                    socketFriend.send(JSON.stringify(json))
                    console.log(friendId, "to ", id)
                }
            }
            // Object.keys(sockets).forEach(function (key) {
            //     if (sockets[key] == ws) {
            //         // console.log("keep sender")
            //     } else {
            //         sockets[key].send(message)
            //         console.log(friendId)
            //     }
            // });
        });

    }
});

