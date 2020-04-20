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
    
    
    
    
}
