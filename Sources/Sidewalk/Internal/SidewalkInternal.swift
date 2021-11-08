import Foundation
import WebKit

class SidewalkInternal: SidewalkInterface {

    weak var customMessageHandler: SidewalkSocketMessageHandler?
    
    init() {
        _ = SidewalkSocketServer.shared()
    }
    
    func attachToWebView(_ webview: WKWebView, when: WKUserScriptInjectionTime) {
        let id = SidewalkIdGenerator.incrementId()
        webview.sidewalkId = id
        webview.sidewalkMessageHandler = customMessageHandler ?? SidewalkSocketMessageHandlerDefault(webview: webview)
        WKWebView.webviewReferenceHolder.updateValue(SidewalkWeakReference(webview), forKey: id)

        let script =
            readAsset(fileName: "sidewalk", ext: "js")! + "; " +
            "initSidewalk(" +
                id.description + "," +
                SidewalkSocketServer.shared().port().description +
            ");"
        
        webview.configuration.userContentController.addUserScript(
            WKUserScript(
                source: script,
                injectionTime: when,
                forMainFrameOnly: true)
        )
    }
    
    func injectNow(_ webview: WKWebView) {
        let id = SidewalkIdGenerator.incrementId()
        webview.sidewalkId = id
        webview.sidewalkMessageHandler = customMessageHandler ?? SidewalkSocketMessageHandlerDefault(webview: webview)
        WKWebView.webviewReferenceHolder.updateValue(SidewalkWeakReference(webview), forKey: id)
        
        let script =
            readAsset(fileName: "sidewalk", ext: "js")! + "; " +
            "initSidewalk(" +
                id.description + "," +
                SidewalkSocketServer.shared().port().description +
            ");"
        
        webview.evaluateJavaScript(script, completionHandler: { data, error in
            if let error = error {
                print("[!!! SIDEWALK ERROR]: ", error)
                return
            }
        })
    }
    
    func forgetWebview(_ webview: WKWebView) {
        if let id = webview.sidewalkId {
            //TODO: check, this is already storead as weak ref
            webview.sidewalkWebsocket = nil
            webview.sidewalkMessageHandler = nil
            WKWebView.webviewReferenceHolder.removeValue(forKey: id)
        }
    }
    
    func setCustomSocketMessageHandler(_ messageHandler: SidewalkSocketMessageHandler) {
        customMessageHandler = messageHandler
    }

}
