//
//  DataModel.swift
//  CavistaCodeChallangeApp
//
//  Created by Susanta Mukherjee on 30/10/2020.
//  Copyright © 2020 Susanta Mukherjee. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper


class Contents: Object,Mappable {
    
    @objc dynamic var id : String? = ""
    @objc dynamic var type : String? = ""
    @objc dynamic var date : String? = ""
    @objc dynamic var data : String? = ""
    
    required convenience init?(map: Map) {
        
        self.init()
    }
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        type <- map["type"]
        date <- map["date"]
        data <- map["data"]
    }
}

