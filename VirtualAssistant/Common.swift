//
//  Common.swift
//  VirtualAssistant
//
//  Created by MZaher on 7/4/18.
//  Copyright © 2018 MZaher. All rights reserved.
//

import MessageUI


protocol ChatDelegate {
    func presentInChat(text: String, fromUser: Bool) -> Void
    
    func presentInToast(text: String) -> Void
    
    func promptUserForMoreInfo() -> Void
    
    func messageComposerHandler(messageComposerView: MFMessageComposeViewController) -> Void
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
    static let confirm : String = "confirm"
    static let cancel : String = "cancel"
    
    static let flashlightOnIntent : String = "flash_on"
    static let flashlightOffIntent : String = "flash_off"
    
    static let openApps : String = "open_apps"
    static let openLog : String = "call_log_show"
    static let openContacts : String = "contacts_show"
    static let openSMS : String = "sms_show"
    static let openMusic : String = "music"
    static let openCamera : String = "camera"
    static let openPhotos : String = "gallery"
    
    static let googleSearch : String = "google_search"
    
    static let wifiOn : String = "wifi_on"
    static let wifiOff : String = "wifi_off"
    
    static let bluetoothOn : String = "bluetooth_on"
    static let bluetoothOff : String = "bluetooth_off"
    
    static let modeNormal : String = "mode_normal"
    static let modeSilent : String = "mode_silent"
    static let modeVibration : String = "mode_vibration"
    
    static let sendSMS : String = "sms_send"
    
    
    // Other Entities
    static let appName : String = "app_name"
    static let googleSearchText : String = "search_free_text"
    
}
