//
//  SuperAppHelper.swift
//  SuperApp
//
//  Created by QTS Coder on 26/3/25.
//

import Foundation

class SuperAppHelper{
    static let shared = SuperAppHelper()
    private let key = "savedNumbers"
    private let defaults = UserDefaults.standard

    // Lưu mảng số nguyên vào UserDefaults
    func save(numbers: [Int]) {
        defaults.set(numbers, forKey: key)
    }

    // Lấy mảng số nguyên từ UserDefaults
    func getNumbers() -> [Int] {
        return defaults.array(forKey: key) as? [Int] ?? []
    }

    // Thêm một số vào mảng
    func addNumber(_ number: Int) {
        var numbers = getNumbers()
        numbers.append(number)
        save(numbers: numbers)
    }

    // Xóa một số khỏi mảng
    func removeNumber(_ number: Int) {
        var numbers = getNumbers()
        numbers.removeAll { $0 == number }
        save(numbers: numbers)
    }

    // Xóa toàn bộ dữ liệu
    func clear() {
        defaults.removeObject(forKey: key)
    }
}
