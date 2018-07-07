//
//  ReadyState.swift
//  VirtualAssistant
//
//  Created by MZaher on 7/4/18.
//  Copyright © 2018 MZaher. All rights reserved.
//

import Foundation
import SwiftyJSON


protocol BaseFunctionality {
    
    func whatNextState(response :JSON) -> BaseFunctionality?
    
    func processResponse(response :JSON) -> Void
    
}


class ReadyState : BaseFunctionality{
    
    func whatNextState(response: JSON) -> BaseFunctionality? {
        guard let intent = response[Common.witEntities][Common.witIntent][0][Common.value].string else {print("No Intent Found"); return nil}
        
        guard let confidence = response[Common.witEntities][Common.witIntent][0][Common.confidence].double else {return nil}
        
        if confidence < Common.threshold{print("Abort, Low Confidence"); return nil}
        
        if intent == Common.flashlightOnIntent || intent == Common.flashlightOffIntent{
            return FlashlightFunctionality()
        }
        
        else{
            return self
        }
        
    }
    
    
    func processResponse(response: JSON) {
        let state = whatNextState(response: response)
        state?.processResponse(response: response)
    }
    
    
}
