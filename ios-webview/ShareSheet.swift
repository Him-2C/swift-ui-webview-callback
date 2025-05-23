import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
  var dataList: [Any] = []
  
  func makeUIViewController(context: Context) -> UIActivityViewController {
    let controller = UIActivityViewController(activityItems: dataList, applicationActivities: nil)
    return controller;
  }
  
  func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    
  }
}
