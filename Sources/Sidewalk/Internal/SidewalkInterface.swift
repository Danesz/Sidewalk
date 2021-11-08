import Foundation
import WebKit

protocol SidewalkInterface {
    func attachToWebView(_ webview: WKWebView, when: WKUserScriptInjectionTime)
    func injectNow(_ webview: WKWebView)
    func forgetWebview(_ webview: WKWebView)
    func setCustomSocketMessageHandler(_ messageHandler: SidewalkSocketMessageHandler)
}
