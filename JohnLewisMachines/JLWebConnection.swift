//
//  JLWebConnection.swift
//  JohnLewisMachines
//
//  Created by TAE on 23/02/2017.
//  Copyright © 2017 TAE. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

private typealias JSONObject = [String : AnyObject]


final class ConnectionFile {
    static let sharedInstance = ConnectionFile()
    
   
    var machines: [Machine] = []
    var productInfo :AnyObject?
    
    
    // API base URL.
    private let apiBaseURL = "https://api.johnlewis.com/v1/products/"
//"https://api.johnlewis.com/v1/products/search?q=dishwasher&key=Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb&pageSize=20"
    private let productURL = "https://api.johnlewis.com/v1/products/{productId}?key=Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb"
    
    
    func fetchAllMachines(completion: @escaping ([Machine]) -> Void) {
        get(endpoint:"search?q=dishwasher&key=Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb&pageSize=20"){ JSON in
            if let response = JSON as? [String:AnyObject]{
                print("JSON machines response: \(response)")
                let machinesArray = response["products"] as! [AnyObject]
                for eachMachine in machinesArray{
                    self.machines.append(Machine(dictionary: eachMachine as! [String : AnyObject]))
                  //  print(self.machines.count)
                }
                completion(self.machines)
            }
            
        }}
    
  
    func fetchProductInfo(productID:String, completion: @escaping (AnyObject?) -> Void) {
        
        
        
        let target =  productID + "?key=Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb"
        
        get(endpoint: target){ JSON in
            completion(JSON as AnyObject?)

//            if let response = JSON as AnyObject?
//            {
//                print("JSON machines response: \(response)")
//    
//
//           }
            
        }
        
        
        
        
    
    
    
    
    }

    
    // Convenience method to perform a GET request on an API endpoint.
    private func get(endpoint: String, completion: @escaping (AnyObject?) -> Void) {
        request(endpoint:endpoint, method: .get, parameters: nil, completion: completion)
    }
    
    
    private func request(endpoint: String, method: HTTPMethod, parameters: [String: AnyObject]?, completion: @escaping (AnyObject?) -> Void) {
        
        
        guard let URL = URL(string: apiBaseURL + endpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        print("Starting \(method) \(URL) (\(parameters ?? [:]))")
        Alamofire.request(URL, method: method, parameters: parameters).responseJSON {response in
            //   print("Finished \(method) \(URL): \(response?.statusCode)")
            print("\(response.request)")  // original URL request
            print("\(response.response)") // URL response
            print("\(response.data)")     // server data
            print("\(response.result)")   // result of response serialization
            switch response.result {
            case .success(let JSON):
                completion(JSON as AnyObject?)
            case .failure(let error):
                print("Request failed with error: \(error)")
                
                completion(nil)
            }
        }
    }
}










