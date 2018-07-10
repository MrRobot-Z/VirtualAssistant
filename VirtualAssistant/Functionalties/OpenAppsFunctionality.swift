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
        
        // Native Apps:
        appList["Music"] = "music://"
        //appList["App Store"] = "itms-apps://itunes.apple.com"
        appList["Photos"] = "Photos-redirect://"
        appList["Contacts"] = "contacts://"
        appList["Calender"] = "calshow://"
        appList["SMS"] = "sms://"

        
        
        // Third Party Apps:
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
        appList["الجي ميل"] = "googlegmail://"
        appList["هانجوتس"] = "com.google.hangouts://"
        appList["التروكولر"] = "truecaller://"
        appList["شيرت"] = "shareit://"
        appList["اوبر"] = "uber://"
        appList["كريم"] = "careem://"
        appList["شازام"] = "shazam://"
        appList["كام سكانر"] = "camscanner://"
        appList["فايبر"] = "viber://"
        appList["رتريكا"] = "retrica://"
    }
    
    func whatNextState(response: JSON) -> BaseFunctionality {
        
        return self
    }
    
    
    func processResponse(response: JSON) -> BaseFunctionality {
        // MARK: Open Gallery
        if response[Common.witEntities][Common.witIntent][0][Common.value].stringValue == Common.openPhotos{
            
            let appName = "Photos"
            if UIApplication.shared.canOpenURL(URL(string:  appName)!){
                UIApplication.shared.openURL(URL(string: appList[appName]!)!)
            } else{
                delegate?.presentInChat(text: "لسه الابلكيشن ده معرفش افتحه", fromUser: false)
            }
        }
        // MARK: Open Contacts
        if response[Common.witEntities][Common.witIntent][0][Common.value].stringValue == Common.openContacts{
            
            let appName = "Contacts"
            if UIApplication.shared.canOpenURL(URL(string:  appName)!){
                UIApplication.shared.openURL(URL(string: appList[appName]!)!)
            } else{
                delegate?.presentInChat(text: "لسه الابلكيشن ده معرفش افتحه", fromUser: false)
            }
        }
        // MARK: Open Music
        if response[Common.witEntities][Common.witIntent][0][Common.value].stringValue == Common.openMusic{
            
            let appName = "Music"
            if UIApplication.shared.canOpenURL(URL(string:  appName)!){
                UIApplication.shared.openURL(URL(string: appList[appName]!)!)
            } else{
                delegate?.presentInChat(text: "لسه الابلكيشن ده معرفش افتحه", fromUser: false)
            }
        }
        // MARK: Open SMS
        if response[Common.witEntities][Common.witIntent][0][Common.value].stringValue == Common.openSMS{
            
            let appName = "SMS"
            if UIApplication.shared.canOpenURL(URL(string:  appName)!){
                UIApplication.shared.openURL(URL(string: appList[appName]!)!)
            } else{
                delegate?.presentInChat(text: "لسه الابلكيشن ده معرفش افتحه", fromUser: false)
            }
        }
        
        // MARK: Open Apps
        if response[Common.witEntities][Common.witIntent][0][Common.value].stringValue == Common.openApps{
            
            if let appName = response[Common.witEntities][Common.appName][0][Common.value].string{
                
                let appNameConfidence = response[Common.witEntities][Common.appName][0][Common.confidence].double!
                if appNameConfidence < Common.threshold {
                    return ReadyState()
                }
                
                
                print(appName)
                if appList.keys.contains(appName) {
                    if UIApplication.shared.canOpenURL(URL(string:  appList[appName]!)!){
                        // MARK: Application Can be oppened
                        UIApplication.shared.openURL(URL(string: appList[appName]!)!)
                    } else{
                        // MARK: Application Not Found on device
                        delegate?.presentInChat(text: "مش لاقية الابلكيشن ده على الموبايل", fromUser: false)
                    }
                }
                else{
                    delegate?.presentInChat(text: "لسه معرفش افتح الابلكيشن ده", fromUser: false)
                }
                
            }else{
                
                delegate?.presentInChat(text: "تمام ايه اسم الابلكيشن اللى عايز تفتحه", fromUser: false)
                delegate?.promptUserForMoreInfo()
                return self
            }
            
        }
        
        return ReadyState()
    }
    
}
