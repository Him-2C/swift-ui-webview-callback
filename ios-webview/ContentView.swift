//
//  ContentView.swift
//  ios-webview
//
//  Created by Chakkrit Chueangyang on 23/5/2568 BE.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
      WebView(url: URL(string: "http://192.168.68.52:3000")!).ignoresSafeArea(edges: .all)
    }
}

#Preview {
    ContentView()
}
