//
//  Visitor.swift
//  CircleCue
//
//  Created by QTS Coder on 11/10/20.
//

import Foundation

struct Visitor {
    var country: String = ""
    var countt: Int = 0
    
    init(dic: NSDictionary) {
        if let country = dic.value(forKey: "country") as? String {
            self.country = country
        }
        if let countt = dic.value(forKey: "countt") as? Int {
            self.countt = countt
        }
    }
}
