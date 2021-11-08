import WebKit

public class Sidewalk: SidewalkInterface {
    
    // MARK: - Properties

    private static var sharedInstance: Sidewalk = {
        let instance = Sidewalk()
        return instance
    }()

    // MARK: -

    private let sidewalkInternal: SidewalkInterface

    // Initialization

    private init() {
        sidewalkInternal = SidewalkInternal()
    }

    // MARK: - Accessors

    public class func shared() -> Sidewalk {
        return sharedInstance
    }
    /**
     Inject Sidewalk into the webview at page loading time.
     NOTE: this method has to be called before the webview loaded the page,
     */
    
    //TODO: provide initialization callback
    public func attachToWebView(_ webview: WKWebView, when: WKUserScriptInjectionTime) {
        sidewalkInternal.attachToWebView(webview, when: when)
    }
    
    /**
     Inject Sidewalk into the webview at the desired moment
     */
    
    //TODO: provide initialization callback
    public func injectNow(_ webview: WKWebView) {
        sidewalkInternal.injectNow(webview)
    }
    
    /**
     Clean-up the webview reference
     
     NOTE: the build up a proper socket communication we had to save a reference for the webview... this method notifies the SDK do the clean-up and avoid memory leaks.
     */
    
    public func forgetWebview(_ webview: WKWebView) {
        sidewalkInternal.forgetWebview(webview)
    }
    
    /**
     Implement custom message handler for different socket communication
     
     NOTE: Make sure you hold a strong reference to the messageHandler!
     NOTE: Use it with cooperation in Javascript ---> Sidewalk.customMessageHandler = function(event){...}
     */
    public func setCustomSocketMessageHandler(_ messageHandler: SidewalkSocketMessageHandler) {
        sidewalkInternal.setCustomSocketMessageHandler(messageHandler)
    }
}
