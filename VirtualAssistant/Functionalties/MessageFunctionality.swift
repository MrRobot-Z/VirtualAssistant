//
//  MessageFunctionality.swift
//  VirtualAssistant
//
//  Created by MZaher on 7/10/18.
//  Copyright © 2018 MZaher. All rights reserved.
//

import Foundation
import MessageUI
import SwiftyJSON


class MessageFunctionality: NSObject, MFMessageComposeViewControllerDelegate, BaseFunctionality{
    
    var delegate: ChatDelegate?
    
    var textMessageRecipients = [""]
    var messageBody : String = ""
    
    func whatNextState(response: JSON) -> BaseFunctionality {
        return self
    }
    
    func processResponse(response: JSON) -> BaseFunctionality {
        if !canSendText() {
            delegate?.presentInChat(text: "سورى الجهاز ميقدرش يبعت رسايل", fromUser: false)
            return ReadyState()
        }
        
        
        
        return self
    }
    
    
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    func configuredMessageComposeViewController() -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
        messageComposeVC.recipients = textMessageRecipients
        messageComposeVC.body =  messageBody
        return messageComposeVC
    }
    

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
