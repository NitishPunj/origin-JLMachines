//
//  WebServiceTests.swift
//  JohnLewisMachines
//
//  Created by TAE on 28/02/2017.
//  Copyright © 2017 TAE. All rights reserved.
//

import XCTest
@ testable import JohnLewisMachines
class WebServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testProductDataFromApi(){
    
        
        let productId = "2423424"
   
        XCTAssertNotNil (ConnectionFile.sharedInstance.fetchProductInfo(productID:productId ){_ in })
       
    }
    
    func testProductCount(){
    
    let productCount = 20
        
        
        
        ConnectionFile.sharedInstance.fetchAllMachines(){machines in
           
            
            XCTAssertEqual(machines.count, productCount)
        }
        
    }
    
    
    
    
    
    
    
}
