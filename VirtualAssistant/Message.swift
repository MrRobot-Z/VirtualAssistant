//
//  Message.swift
//  VirtualAssistant
//
//  Created by MZaher on 7/7/18.
//  Copyright © 2018 MZaher. All rights reserved.
//

import Foundation

class Message{
    
    var messageText : String = ""
    var isUserSender = false
    
    init() {}
    
    init(text: String, isUser: Bool) {
        self.messageText = text
        self.isUserSender = isUser
    }
}


