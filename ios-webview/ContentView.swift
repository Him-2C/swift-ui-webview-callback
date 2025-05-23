//
//  ContentView.swift
//  ios-webview
//
//  Created by Chakkrit Chueangyang on 23/5/2568 BE.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
      WebView(url: URL(string: "http://127.0.0.1:3000")!).ignoresSafeArea(edges: .all)
    }
}

#Preview {
    ContentView()
}
