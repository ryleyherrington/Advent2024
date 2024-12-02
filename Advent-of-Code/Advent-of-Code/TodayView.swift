//
//  TodayView.swift
//  Advent-of-Code
//
//  Created by Ryley on 12/2/24.
//

import SwiftUI
import WebKit

struct TodayView: UIViewRepresentable {
    let url: URL = URL(string: "https://adventofcode.com/2024/day/\(Calendar.current.component(.day, from: Date()))")!

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
