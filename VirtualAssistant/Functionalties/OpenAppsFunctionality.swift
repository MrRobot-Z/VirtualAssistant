//
//  OpenAppsFunctionality.swift
//  VirtualAssistant
//
//  Created by MZaher on 7/9/18.
//  Copyright © 2018 MZaher. All rights reserved.
//

import Foundation
import SwiftyJSON


class OpenAppsFunctionality: BaseFunctionality{
    
    
    var delegate: ChatDelegate?
    
    func whatNextState(response: JSON) -> BaseFunctionality {
        
        return self
    }
    
    func processResponse(response: JSON) -> BaseFunctionality {
        
        return self
    }
    
    
}
