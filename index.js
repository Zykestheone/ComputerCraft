const socket = require("ws");
var clients = [];
const webSocket = new socket.Server({port:5656});

webSocket.on("connection", wsClient => {

    console.log("Something Connected")
    clients.push(wsClient);

    wsClient.on("message", messageData => {

        console.log("Received Message: "+messageData.toString());

        clients.forEach(function(client){
            client.send(messageData.toString());
        });

    })

    wsClient.on("close",() => {
        console.log("Something Disconnected");
    })
})