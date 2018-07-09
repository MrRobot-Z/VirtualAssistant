//
//  Common.swift
//  VirtualAssistant
//
//  Created by MZaher on 7/4/18.
//  Copyright © 2018 MZaher. All rights reserved.
//

protocol ChatDelegate {
    func presentInChat(text: String, fromUser: Bool) -> Void
    
    func presentInToast(text: String) -> Void
}

class Common {
    
    // UI Constants
    static let userCell = "User_Send_Cell"
    static let botCell = "Bot_Send_Cell"
    
    static let micOnIcon = "Mic_on"
    static let micOffIcon = "Mic_off"
    static let showKeyboard = "Show_keyboard"
    static let dismissKeyboard = "Dismiss_keyboard"
    
    
    // Wit Constants
    static let threshold : Double = 0.8
    
    static let witOriginalMessage : String = "_text"
    static let witEntities : String = "entities"
    static let witIntent : String = "intent"
    
    static let value : String = "value"
    static let confidence : String = "confidence"
    
    
    // Intents
    static let flashlightOnIntent : String = "flash_on"
    static let flashlightOffIntent : String = "flash_off"
    
    
    
    
}
