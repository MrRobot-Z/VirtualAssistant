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
    
    var delegate : ChatDelegate? {get set}
    
    func whatNextState(response :JSON) -> BaseFunctionality
    
    func processResponse(response :JSON) -> BaseFunctionality
    
}


class ReadyState : BaseFunctionality{
    
    
    var delegate : ChatDelegate?
    
    
    func whatNextState(response: JSON) -> BaseFunctionality {
        guard let intent = response[Common.witEntities][Common.witIntent][0][Common.value].string else {print("No Intent Found"); return self}
        
        guard let confidence = response[Common.witEntities][Common.witIntent][0][Common.confidence].double else {return self}
        
        if confidence < Common.threshold {
            if intent == Common.openApps || intent == Common.openContacts || intent == Common.openPhotos || intent == Common.openSMS || intent == Common.openMusic{
                print("Ignoring low confidence")
            } else{
                print("Abort, Low Confidence")
                return self
            }
        }
        
        var newState: BaseFunctionality?
        if intent == Common.flashlightOnIntent || intent == Common.flashlightOffIntent{
            newState = FlashlightFunctionality()
        }
            
        else if intent == Common.openApps || intent == Common.openContacts || intent == Common.openPhotos || intent == Common.openSMS || intent == Common.openMusic {
            newState = OpenAppsFunctionality()
        }
        
        else if intent == Common.wifiOn || intent == Common.wifiOff || intent == Common.bluetoothOn || intent == Common.bluetoothOff || intent == Common.modeNormal || intent == Common.modeSilent || intent == Common.modeVibration{
            newState = NonSupportedFunctionalities()
        }
            
        else if intent == Common.googleSearch{
            newState = GoogleSearchFunctionality()
        }
            
        else{
            print("No Recognizable intent found")
            newState = self
        }
        newState?.delegate = self.delegate
        return newState!
    }
    
    
    func processResponse(response: JSON) -> BaseFunctionality{
        return self
    }
    

//    func processResponse(response: JSON) -> BaseFunctionality{
//        var state = whatNextState(response: response)
//        if (state != nil) {
//            print("found a new state")
//            state = state.processResponse(response: response)
//        } else {
//            print("No new state ... no Intent")
//            state = self
//        }
//        return state
//    }
    
    
}
