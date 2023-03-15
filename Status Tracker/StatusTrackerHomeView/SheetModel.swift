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
}
