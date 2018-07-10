//
//  GoogleSearchFunctionality.swift
//  VirtualAssistant
//
//  Created by MZaher on 7/10/18.
//  Copyright © 2018 MZaher. All rights reserved.
//

import Foundation
import SwiftyJSON


class GoogleSearchFunctionality: BaseFunctionality{
    
    
    var delegate: ChatDelegate?
    
    let baseURL = "https://www.google.com/search?q="

    
    func whatNextState(response: JSON) -> BaseFunctionality {
        return self
    }
    
    func processResponse(response: JSON) -> BaseFunctionality {
        
        if response[Common.witEntities][Common.witIntent][0][Common.value].stringValue == Common.googleSearch{
            
            if let searchText = response[Common.witEntities][Common.googleSearchText][0][Common.value].string{
                
                search(forText: searchText)
                
            }
            else {
                delegate?.presentInChat(text: "اسيرش على ايه؟؟", fromUser: false)
                return self
            }
            
        }
        else {
            
            guard let vagueText = response[Common.witOriginalMessage].string else{ return ReadyState()}
                
            search(forText: vagueText)
            
        }
        
        
        return ReadyState()
    }
    
    func search(forText : String){
        
        let formattedString = forText.replacingOccurrences(of: " ", with: "+")
        
        delegate?.presentInChat(text: "تمام ديه النتايج اللى لقيتها", fromUser: false)
        print(baseURL+formattedString)
        
        UIApplication.shared.openURL(URL(string: (baseURL + formattedString))!)
        
    }
    
    
    
}
