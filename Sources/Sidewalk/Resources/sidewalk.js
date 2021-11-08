console.log("[+++ SIDEWALK JS +++]")

class SidewalkJS {
    constructor(id, port, debug) {
        this.sidewalkID = id;
        this.port = port;
        this.debug = debug;
    }

    set customMessageHandler(messageHandler) {
        this.socket.onmessage = messageHandler
    }

    init() {
        console.log("[+++ SIDEWALK JS INIT +++]")
        window["SidewalkDEBUG"] = this.debug; //TODO: fix pls
        this.socket = new WebSocket("ws://localhost:"+this.port);
        //text frame looks happy this way too, no need for switching
        this.socket.binaryType = "arraybuffer";
        console.log("[+++ SIDEWALK JS CONNECT ON " + this.port + " +++]")
        this.socket.onopen = event => {
            logSidewalk("[SIDEWALK open] Connection established");
            logSidewalk("[SIDEWALK send] Sending to server");
            this.socket.send(JSON.stringify({"type": "connected", "connectedId": this.sidewalkID}));
        };

        this.socket.onmessage = event =>  {
            //console.log(`[SIDEWALK message] Data received from server: ${event.data}`);
            if (event.data instanceof ArrayBuffer) {
                logSidewalk("binary frame");
                logSidewalk("data start");
                // binary frame
                const view = new DataView(event.data);
                logSidewalk(view.getInt32(0));

                //const value = new TextDecoder().decode(new Uint8Array(event.data));
                //console.log(String.fromCharCode.apply(null, new Uint8Array()));
                //console.log("value", value)
                
                logSidewalk("data end");
            } else {
                // text frame
                logSidewalk("text frame");
                Function('"use strict";' + atob(event.data) )();
            }


        };

        this.socket.onclose = event =>  {
            if (event.wasClean) {
                logSidewalk(`[SIDEWALK close] Connection closed cleanly, code=${event.code} reason=${event.reason}`);
            } else {
                // e.g. server process killed or network down
                // event.code is usually 1006 in this case
                console.log('[SIDEWALK close] Connection died');
            }
        };

        this.socket.onerror = error =>  {
            console.error(`[SIDEWALK ERROR] ${error.message}`);
        };
        
        console.log("[--- SIDEWALK JS INIT ---]")
    }

}

function logSidewalk(args) {
    if (window.SidewalkDEBUG) {
        console.log.apply(console, arguments);
    }
}

function initSidewalk(id, port) {
    console.log("[+++ SIDEWALK JS INIT MAIN +++]")
    var Sidewalk = new SidewalkJS(id, port, true);
    Sidewalk.init();
    window["Sidewalk"] = Sidewalk;
    console.log("[--- SIDEWALK JS INIT MAIN ---]")
}

// NOTE: after initializaiton, you can use:
// Sidewalk.customMessageHandler = function(event){
//    ...
// }
// to override the message handling
// e.g. to parse JSON from SidewalkSocketMessageHandlerJSON:
//
// Sidewalk.customMessageHandler = function(event){
//     let parsed = JSON.parse(event.data);
//     if (parsed.type === "eval") {
//         let scriptToRun = atob(parsed.evalutation)
//         Function('"use strict";' + scriptToRun )();
//     }
// }
