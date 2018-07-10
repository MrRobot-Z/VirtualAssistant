//
//  FlashlightFunctionality.swift
//  VirtualAssistant
//
//  Created by MZaher on 7/4/18.
//  Copyright © 2018 MZaher. All rights reserved.
//

import AVFoundation
import SwiftyJSON

class FlashlightFunctionality : BaseFunctionality{
    
    var delegate : ChatDelegate?
    
    var command : Bool = false
    
    func whatNextState(response: JSON) -> BaseFunctionality {
        return ReadyState()
    }
    
    
    func processResponse(response: JSON) -> BaseFunctionality {
        if response[Common.witEntities][Common.witIntent][0][Common.value].stringValue == Common.flashlightOnIntent{
            command = true
        } else if response[Common.witEntities][Common.witIntent][0][Common.value].stringValue == Common.flashlightOffIntent{
            command = false
        }
        
        stateTorch(on: command)
        return ReadyState()
    }
    
    func stateTorch(on: Bool) {
        print("Setting Torch to : \(on)")

        guard let device = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Guarded ... Couldn't initialize connection to AVCaptureDevice")
                return
        }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on {
                    device.torchMode = .on
                    delegate?.presentInChat(text: "حاضر هشغل الفلاش", fromUser: false)
                } else {
                    device.torchMode = .off
                    delegate?.presentInChat(text: "حاضر هطفى الفلاش", fromUser: false)
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
}
