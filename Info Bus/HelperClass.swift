//
//  HelperClass.swift
//  Info Bus
//
//  Created by Zorro Andrei on 15/04/2020.
//  Copyright © 2020 ZorroAndrei. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit



class Helper {
    
    /*
     * Desc: request line tab -> lines list
     * Controler Caller: LineViewController
    */
    func getAllLines() -> Promise<ResponseAllLines>{
        
        let jsonUrlString = "https://info.stbsa.ro/rp/api/lines?lang=ro"
        
        return Promise<ResponseAllLines>{ resolver in
            Alamofire.request(jsonUrlString).responseString{
                response in
                switch(response.result){
                case .success(let data):
                    
                    if let json = data.data(using: .utf8){
                        do{
                            let res = try JSONDecoder().decode(ResponseAllLines.self, from: json)
                            //print(res)
                            resolver.fulfill(res)
                        }catch{
                            resolver.reject(error)
                        }
                        
                    }
                case .failure(let err):
                    print(err)
                    resolver.reject(err)
                }
            }
        }
    }
    
    
    /*
     * Desc: request stops tab -> stops list
     * Controler Caller: StopsViewController
     */
    func getAllStops() -> Promise<[AllStops]>{
        
        let jsonUrlString = "https://info.stbsa.ro/rp/api/lines/home/stops/44.235789928588724/25.842680347535916/44.776632613361106/26.43472809355702?lang=ro"
        
        return Promise<[AllStops]>{ resolver in
            Alamofire.request(jsonUrlString).responseString{
                response in
                switch(response.result){
                case .success(let data):
                    
                    if let json = data.data(using: .utf8){
                        do{
                            let res = try JSONDecoder().decode([AllStops].self, from: json)
                            //print(res)
                            resolver.fulfill(res)
                        }catch{
                            resolver.reject(error)
                        }
                        
                    }
                case .failure(let err):
                    print(err)
                    resolver.reject(err)
                }
            }
        }
    }
   
    
    /*
     * Desc: requested Stops tab -> lineStop list that came at a specific stop
     * Controler Caller: StopDetailsViewControlller
     */
    func getSpecificStop(stop: Int?, line: Int?) -> Promise<Stop>{
        
        var jsonUrlString = ""
        
        if line == nil{
            jsonUrlString = "https://info.stbsa.ro/rp/api/lines/stops/\(stop!)?lang=ro"
        }else{
            jsonUrlString = "https://info.stbsa.ro/rp/api/lines/\(line!)/stops/\(stop!)?lang=ro"
        }
        
        return Promise<Stop>{ resolver in
            Alamofire.request(jsonUrlString).responseString{
                response in
                switch(response.result){
                case .success(let data):
                    if let json = data.data(using: .utf8){
                        do{
                            let res : Stop?
                            if line == nil{
                                res  = try JSONDecoder().decode(Stop.self, from: json)
                            }else{
                                let response = try JSONDecoder().decode([Stop].self, from: json)
                                res = response[0]
                            }
                            print("------rezult ----- \n\(res!)")
                            resolver.fulfill(res!)
                        }catch{
                            print("eroare Help 1 aici!")
                            resolver.reject(error)
                        }
                        
                    }
                case .failure(let err):
                    print("eroare Help 2 aici!")
                    resolver.reject(err)
                }
            }
        }
    }
    
    
    /*
     * Desc: requested Stops tab -> lineStop list that came at a specific stop
     * Controler Caller: StopDetailsViewControlller
     */
    func getStopsByLine(line: Int?, requestType : Int?) -> Promise<StopsByLine>{
        
        var jsonUrlString = ""
        
        if requestType != nil {
            
            if requestType == 0 { //both direction
                jsonUrlString = "https://info.stbsa.ro/rp/api/lines/\(line!)?lang=ro"
            }else if requestType == 1{
                jsonUrlString = "https://info.stbsa.ro/rp/api/lines/\(line!)/direction/0?lang=ro"
            }else if requestType == 2{
                jsonUrlString = "https://info.stbsa.ro/rp/api/lines/\(line!)/direction/0?lang=ro"
                
            }
        }
        
        return Promise<StopsByLine>{ resolver in
            Alamofire.request(jsonUrlString).responseString{
                response in
                switch(response.result){
                case .success(let data):
                    if let json = data.data(using: .utf8){
                        do{
                            let res = try JSONDecoder().decode(StopsByLine.self, from: json)
                            //print(res)
                            resolver.fulfill(res)
                        }catch{
                            resolver.reject(error)
                        }
                        
                    }
                case .failure(let err):
                    print(err)
                    resolver.reject(err)
                }
            }
        }
    }
    
    
    /*
     * Desc: requested Search tab -> places list starting with "name"
     * Controler Caller: CustomSearchViewControlller
     */
    func getPlaces(startingWith name: String?) -> Promise<PlacesReq>{
        
        let jsonUrlString = "https://info.stbsa.ro/rp/api/places?lang=ro&query=\(name!)"
        
        return Promise<PlacesReq>{ resolver in
            Alamofire.request(jsonUrlString).responseString{
                response in
                switch(response.result){
                case .success(let data):
                    
                    if let json = data.data(using: .utf8){
                        do{
                            let res = try JSONDecoder().decode(PlacesReq.self, from: json)
                            //print(res)
                            resolver.fulfill(res)
                        }catch{
                            resolver.reject(error)
                        }
                        
                    }
                case .failure(let err):
                    print(err)
                    resolver.reject(err)
                }
            }
        }
    }
    
    
    /*
     * Desc: requested Search tab -> list of routes
     * Controler Caller: CustomSearchViewControlller
     */
    func getRoutes(headerBody body: RoutesBody) -> Promise<RoutesResponse>{
        
        let jsonUrlString = "https://info.stbsa.ro/rp/api/routes?lang=ro"
        //let params = body!.toJson()
        let json = try! JSONEncoder().encode(body)
        let params = try! JSONSerialization.jsonObject(with: json, options: []) as! [String:AnyObject]
        //let params = body! as! [String:AnyObject]
        print("\n\n\n")
        //print("--                     --     ------------------- ")
        
        print(params)
         print("\n\n\n")
        let header = ["Content-Type": "application/json"]
        return Promise<RoutesResponse>{ resolver in	
            
            Alamofire.request(jsonUrlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header ).responseString{
            //Alamofire.request(jsonUrlString).responseString{
                response in
                switch(response.result){
                case .success(let data):
                    
                    if let json = data.data(using: .utf8){
                        do{
                            let res = try JSONDecoder().decode(RoutesResponse.self, from: json)
                             print("\n------------------------------------------\n\n")
                            print(res)
                            resolver.fulfill(res)
                        }catch{
                            resolver.reject(error)
                        }
                        
                    }
                case .failure(let err):
                    print(err)
                    resolver.reject(err)
                }
            }
        }
    }
    
    
    func getRoutesBody()-> RoutesBody{
        var bodyObj = RoutesBody()
        
        bodyObj.transport_types.append(TransportType(type: "BUS", name: "Autobuz", selected: true))
        bodyObj.transport_types.append(TransportType(type: "CABLE_CAR", name: "Troleibuz", selected: true))
        bodyObj.transport_types.append(TransportType(type: "TRAM", name: "Tramvai", selected: true))
        bodyObj.transport_types.append(TransportType(type: "SUBWAY", name: "Metrou", selected: true))
        
        bodyObj.organisations.append(Organisation(id: 2, logo: "https://info.stbsa.ro/src/img/avl/metrorex/logos/logo.png", active: true, name: "METROREX", selected: false))
        bodyObj.organisations.append(Organisation(id: 1, logo: "https://info.stbsa.ro/src/img/avl/stbsa/logos/logo.png", active: true, name: "STBSA", selected: true))
        
        return bodyObj
    }
    
    
    
}
