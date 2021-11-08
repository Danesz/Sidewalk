import Foundation
import WebKit
import Telegraph

//MARK: - Private API
extension WKWebView {
    
    static var webviewReferenceHolder: Dictionary<Int, SidewalkWeakReference<WKWebView>> = Dictionary()

    static func findWebviewById(id: Int) -> WKWebView? {
        return webviewReferenceHolder[id]?.value
    }
    
    private struct AssociatedKeys {
        static var sidewalkWebsocket: WebSocket?
        static var sidewalkId: Int?
        static var sidewalkMessageHandler: SidewalkSocketMessageHandler?
    }

    var sidewalkWebsocket: WebSocket? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.sidewalkWebsocket) as? WebSocket? ?? nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.sidewalkWebsocket, newValue as WebSocket?, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN) //weak ref
        }
    }
    
    var sidewalkId: Int? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.sidewalkId) as? Int? ?? nil
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.sidewalkId, newValue as Int?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    var sidewalkMessageHandler: SidewalkSocketMessageHandler? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.sidewalkMessageHandler) as? SidewalkSocketMessageHandler? ?? nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.sidewalkMessageHandler, newValue as SidewalkSocketMessageHandler?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC) //strong ref
        }
    }
    
}

//MARK: - Public API
extension WKWebView {
    public func sidewalkJavaScript(_ javaScriptString: String, completionHandler: ((Any?, Error?) -> Void)? = nil) {
        do {
            if let socket = self.sidewalkWebsocket {
                self.sidewalkMessageHandler?.send(text: javaScriptString, onSocket: socket)
            }
        } catch let error {
            completionHandler?(nil, error)
        }
        completionHandler?("ok", nil) //TODO: return evaluation result
    }
    
    public func sidewalkJavaScript(_ data: Data, completionHandler: ((Any?, Error?) -> Void)? = nil) {
        do {
            if let socket = self.sidewalkWebsocket {
                self.sidewalkMessageHandler?.send(data: data, onSocket: socket)
            }
        } catch let error {
            completionHandler?(nil, error)
        }
        completionHandler?("ok", nil) //TODO: return evaluation result
    }
}
