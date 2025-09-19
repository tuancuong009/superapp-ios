//
//  NearestUser.swift
//  CircleCue
//
//  Created by QTS Coder on 10/30/20.
//

import Foundation

struct NearestUser {
    var id: String?
    var name: String?
    var lat: Double?
    var lng: Double?
    var distance: String?
    var center: Bool?
    var dis: String?
    
    init(dic: NSDictionary?) {
        guard let dic = dic else { return }
        if let id = dic.value(forKey: "id") as? String {
            self.id = id
        }
        if let name = dic.value(forKey: "name") as? String {
            self.name = name
        }
        if let lat = dic.value(forKey: "lat") as? Double {
            self.lat = lat
        }
        if let lng = dic.value(forKey: "lng") as? Double {
            self.lng = lng
        }
        if let distance = dic.value(forKey: "distance") as? String {
            self.distance = distance
        }
        if let center = dic.value(forKey: "center") as? Bool {
            self.center = center
        }
        if let dis = dic.value(forKey: "dis") as? String {
            self.dis = dis
        }
    }
}
