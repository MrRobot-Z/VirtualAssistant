//
//  NonSupportedFunctionalities.swift
//  VirtualAssistant
//
//  Created by MZaher on 7/10/18.
//  Copyright © 2018 MZaher. All rights reserved.
//

import Foundation
import SwiftyJSON

class NonSupportedFunctionalities: BaseFunctionality {
    
    
    var delegate: ChatDelegate?
    
    func whatNextState(response: JSON) -> BaseFunctionality {
        return self
    }
    
    func processResponse(response: JSON) -> BaseFunctionality {
        
        guard let intent = response[Common.witEntities][Common.witIntent][0][Common.value].string else {return ReadyState()}
        
        if intent == Common.wifiOn || intent == Common.wifiOff || intent == Common.bluetoothOn || intent == Common.bluetoothOff || intent == Common.modeNormal || intent == Common.modeSilent || intent == Common.modeVibration{
            let settingsURL = "App-Prefs:"
            
            delegate?.presentInChat(text: "انا مقدرش انفذ الطلب كامل ... هافتحلك ال Settings و أنت اتعامل", fromUser: false)
            
            UIApplication.shared.openURL(URL(string: settingsURL)!)
        }
        
        return ReadyState()
    }
}
