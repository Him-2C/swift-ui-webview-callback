import SwiftUI

struct ContentView: View {
  @State var isShowSheet: Bool = false
  @StateObject var dataList = StateRef()

  
  func onShareImage(image: UIImage) {
    dataList.current = [image];
    isShowSheet = true
  }
  
  var body: some View {
    WebView(url: URL(
      string: "http://127.0.0.1:3000")!,
            onShareImage: onShareImage)
    .ignoresSafeArea(edges: .all)
    .sheet(isPresented: $isShowSheet, content: {
      ShareSheet(dataList: dataList.current as! [Any])
    })
  }
}

class StateRef: ObservableObject {
  var current: Any?
}

#Preview {
  ContentView()
}
