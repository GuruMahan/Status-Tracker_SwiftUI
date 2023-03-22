//
//  Model.swift
//  Status Tracker
//
//  Created by Guru Mahan on 13/03/23.
//

import Foundation
import SwiftUI

struct SheetModel: Codable {
    var items: [Item]?
}

struct Item: Codable {
    var date: String?
    var datas: [DataElement]?
  
   
   
}

struct DataElement: Codable {
    var name: String?
    var task: String?
    var text: String = ""
    
    enum CodingKeys: String,CodingKey {
        case name
        case task
    }
    func copy(with zone: NSZone? = nil) -> DataElement {
        var copy = DataElement()
        copy.name = name
        copy.task = task
       return copy
    }
}


