//
//  WitModule.swift
//  VirtualAssistant
//
//  Created by MZaher on 7/3/18.
//  Copyright © 2018 MZaher. All rights reserved.
//


import Foundation
import Alamofire
import SwiftyJSON

protocol WitDelegate {
    func recieveResponse(response: JSON) -> Void
}

class WitModule{
    
    var delegate: WitDelegate?
    
    let baseURL = "https://api.wit.ai/message"
    let witAppToken = " Bearer AAP6LXNLDDYAAPZKEITCHO3UT4DGUCRC"
    
    let date = "1/7/2018"
    
    func witNetwork(toBeSentString : String){
        
        let params : [String : String] = ["v" : date , "q" : toBeSentString]
        let authHeader : [String : String] = ["Authorization" : witAppToken]
        
        print("to be sent: " + toBeSentString)
        
        
        Alamofire.request(baseURL, method: .get, parameters: params, headers: authHeader).responseJSON { (response) in
            if response.result.isSuccess{
                print("Success ... Got data from Wit.ai")
                
                let witResponse = JSON(response.result.value!)
                
                self.delegate?.recieveResponse(response: witResponse)
                
            } else {
                print("Error: \(response.result.error!)")
            }
        }
    }
    
}
