//
//  Machine.swift
//  JohnLewisMachines
//
//  Created by TAE on 23/02/2017.
//  Copyright © 2017 TAE. All rights reserved.
//

import Foundation
import SwiftyJSON
class Machine {
 
    
    
   
    let id: String
    let title: String
    let imageURL: String
  
    let price: String
   

    
    init(id: String, title: String, imageURL: String, price: String) {
        self.id = id
   
        self.title = title
        self.imageURL = imageURL
        self.price = price
    
    }
    
    
    
    
    init(dictionary: [String : AnyObject]) {
       
        
        self.id = dictionary["productId"] as! String
       self.title = (dictionary["title"] as! String)
       self.imageURL = "https:"+(dictionary["image"] as! String)
        let priceDic = dictionary["price"]!
        self.price = "£"+(priceDic["now"] as! String)
        
        
    }

}
