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

//getPlaces
struct PlacesReq: Decodable{
    var places:[Place]?
}
//getPlaces
struct Place: Decodable{
    var name: String?
    var lat: Float?
    var lng: Float?
    var type: String?
    var description: String?
}

//getRoutes body
struct RoutesBody: Encodable{
    var start_time: Int?
    var start_lat: Float?
    var start_lng: Float?
    var stop_lat: Float?
    var stop_lng: Float?
    var max_walk_distance: Int = 1000
    var transport_types: [TransportType]?
    var organisations: [Organisation]?
}
//getRoutes body
struct TransportType: Encodable {
    var type: String?
    var name: String?
    var selected: Bool?
}

//getRoutes body
struct Organisation: Encodable {
    var id: Int?
    var logo: String?
    var active: Bool?
    var name: String?
    var selected: Bool?
}


struct RoutesResponce: Decodable {
    var routes:[Route]?
}

//getRoutes response
struct Route: Decodable {
    var duration: Int?
    var segments: [Segment]?
    var start_time: String?
    var stop_time: String?
    var number_of_people: Int?
}

//getRoutes response
struct Segment: Decodable {
    var stops: [RouteStop]?
    var transport_type: String?
    var transport_name: String?
    var start_time: String?
    var stop_time: String?
    var direction_name: String?
    var duration: Int?
    var number_of_people: Int?
}

//getRoutes response
struct RouteStop: Decodable {
    var name: String?
    var time: String?
}
