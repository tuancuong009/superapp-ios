//
//  LogWrapper.swift


import Foundation

func LOG(_ format: String = "", _ args: [CVarArg] = [],
         file: String = #file, function: String = #function, line: Int = #line) {
    let filename = URL(fileURLWithPath: file).lastPathComponent.components(separatedBy: ".").first ?? "Unkown File"

    #if DEBUG
    print("\n")
    print("👉👉👉👉👉👉 🖨 👈👈👈👈👈👈")
    print("\(filename).\(function) line \(line) $ \(format)")
    print("🚧 🚧 🚧 🚧 🚧 🚧 🚧 🚧 🚧 🚧")
    print("\n")
    #endif
}
