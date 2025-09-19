//
//  SafariView.swift
//  Karkonex
//
//  Created by QTS Coder on 8/1/25.
//


import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // Không cần làm gì ở đây
    }
}
