const WebS = require("ws")
const wss = new WebS.Server({port:5656})

wss.on("connection",ws=>{
    console.log("connection!")
    ws.on("message",msg=>{
        wss.broadcast(JSON.stringify({func:msg.toString()}))
        console.log("Received Message: "+msg.toString())
    })
});

wss.broadcast = function broadcast(msg){
    wss.clients.forEach(function each(client) {
        client.send(msg)
    });
};
