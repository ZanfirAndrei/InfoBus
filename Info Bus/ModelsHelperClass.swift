//
//  ModelsHelperClass.swift
//  Info Bus
//
//  Created by Zorro Andrei on 17/04/2020.
//  Copyright © 2020 ZorroAndrei. All rights reserved.
//

import Foundation
import ObjectMapper

//getAllLines
struct ResponseAllLines: Decodable {
    var lines: [AllLines]?
}
//getAllLines
struct AllLines: Decodable {
    var id: Int?
    var name: String?
    var type: String?
}
//getAllStops
struct AllStops: Decodable{
    var id: Int?
    var name: String?
    var type: String?
    
}
//getSpecificStop
struct Stop: Decodable{
    var lines: [Lines]?
    var name: String?
    var description: String?
    var transport_type: String?
}
//getSpecificStop
struct Lines: Decodable{
    var id: Int?
    var name: String?
    var type: String?
    var direction_name: String?
    var arriving_time: Int?
}

//getStopsByLine
struct StopsByLine: Decodable{
    var stops: [Stops]?
    var direction_name_tur: String?
    var direction_name_retur: String?
}

//getStopsByLine
struct Stops: Decodable {
    var id: Int?
    var name: String?
    var description: String?
}
