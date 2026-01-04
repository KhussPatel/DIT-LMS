//
//  AppConst.swift
//  BrittsImperial
//
//  Created by Khuss on 07/10/23.
//

import Foundation


struct AppConstants {
    
    //let mainURL = "http://app.brittsimperial.com/webservice.asmx"
    
    //let mainURL = "http://app.nortwest.edu.au/webservice.asmx"
    
    //let mainURL = "http://appv2.nortwest.edu.au/webservice.asmx"
    
    //let mainURL = "http://appv2.brittscollege.edu.au/webservice.asmx"
    
    //let mainURL = "http://app.actb.com.au/webservice.asmx"
    
    //let mainURL = "http://app.menzies.vic.edu.au/webservice.asmx"
    
    let mainURL = "http://app.dit.edu.au/webservice.asmx"
}


struct Constants {
    static var selectedMenu: selectedMenu = .Assignement
    static var unicodeBulletPoint = "\u{2022}"
 }



enum selectedMenu:String {
case Assignement = "assignment"
    case Course = "course"
    case Video = "video"
}
