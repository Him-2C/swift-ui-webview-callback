import SwiftUI
import WebKit
import UIKit

struct WebView: UIViewRepresentable {
  let url: URL
  let onShareImage: (UIImage) -> Void
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(onShareImage: self.onShareImage)
  }
  
  func makeUIView(context: Context) -> WKWebView  {
    let request = URLRequest(url: url)
    let wkwebView = WKWebView()
    
    context.coordinator.webView = wkwebView;
    wkwebView.configuration.userContentController.add(context.coordinator, name: "observer");
    wkwebView.load(request)
    
    return wkwebView
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) {
    //
  }
}

extension WebView {
  class Coordinator: NSObject, WKScriptMessageHandler {
    var webView: WKWebView? = nil;
    var onShareImage: (UIImage) -> Void
    
    init(onShareImage: @escaping ((UIImage) -> Void)) {
      self.onShareImage = onShareImage
    }
    
    func saveImageToGallery(from base64: String) {
      guard let imageData = Data(base64Encoded: base64),
            let image = UIImage(data: imageData) else {
        print("Invalid Base64 or image data")
        return
      }
      
      UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    func shareImage(from base64: String) {
      guard let imageData = Data(base64Encoded: base64),
            let image = UIImage(data: imageData) else {
        print("Invalid Base64 or image data")
        return
      }
      
      self.onShareImage(image)
    }
    
    func callbackWebView(command: String, payload: [String : Any]) {
      print(command)
      let calbackCommand = "\(command)Callback";
      let calbackErrorCommand = "\(command)CallbackError";
      
      switch command {
      case "internalPartnerInitAuth":
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
          self.webView!.evaluateJavaScript("window.bridge?.\(calbackCommand)('123456789');");
        }
      case "internalPartnerPinVerify":
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          self.webView!.evaluateJavaScript("window.bridge?.\(calbackCommand)('123456789');");
        }
        break;
      case "openEmailSetting":
        webView!.evaluateJavaScript("window.isTestError ? window.bridge?.\(calbackErrorCommand)() : window.bridge?.\(calbackCommand)()");
        break;
      case "saveImageToGallery":
        saveImageToGallery(from: payload["base64Str"] as! String)
        webView!.evaluateJavaScript("window.isTestError ? window.bridge?.\(calbackErrorCommand)() : window.bridge?.\(calbackCommand)()");
        break;
      case "shareImage":
        shareImage(from: payload["base64Image"] as! String)
        break;
      default:
        break;
      }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
      let payload = message.body as! [String : Any];
      let command = payload["name"] as! String;
      
      self.callbackWebView(command: command, payload: payload)
    }
  }
}
