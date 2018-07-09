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
    
    var appList = [String : String]()
    
    var delegate: ChatDelegate?
    
    var didAskForApp = false
    
    
    init() {
        appList["الفيسبوك"] = "fb://"
        appList["الواتس اب"] = "whatsapp://"
        appList["سناب شات"] = "snapchat://"
        appList["انستجرام"] = "instagram://"
        appList["تويتر"] = "twitter://"
        appList["سكايب"] = "skype://"
        appList["الماسنجر"] = "fb-messenger://"
        appList["اليوتيوب"] = "youtube://"
        appList["ساوندكلاود"] = "Soundcloud://"
        appList["انغامي"] = "anghami://"
        appList["جوجل درايف"] = "googledrive://"
        appList["جوجل مابس"] = "googlemaps://"
        appList["جوجل كروم"] = "googlechrome://"
    }
    
    func whatNextState(response: JSON) -> BaseFunctionality {
        
        return self
    }
    
    func processResponse(response: JSON) -> BaseFunctionality {
        if response[Common.witEntities][Common.witIntent][0][Common.value].stringValue == Common.openApps{
            
            if let appName = response[Common.witEntities][Common.appName][0][Common.value].string{
                
                print(appName)
                if appList.keys.contains(appName) {
                    UIApplication.shared.openURL(URL(string: appList[appName]!)!)
                }
                else{
                    print("Not In Dictionary")
                }
                
            }else{
                
                print("Entered Else")
            }
            
        }
        
        
        return ReadyState()
    }
    
}
