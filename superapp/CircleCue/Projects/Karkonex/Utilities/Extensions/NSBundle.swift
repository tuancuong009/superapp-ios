//
//  NSBundle.swift
//  Karkonex
//
//  Created by QTS Coder on 16/04/2024.
//
import UIKit
import SwiftUI
extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    var releaseVersionNumberPretty: String {
        return "\(releaseVersionNumber ?? "1.0.0")"
    }
}
