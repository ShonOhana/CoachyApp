//
//  Video.swift
//  CoachyFitApp
//
//  Created by Mac on 14/05/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation

class Video: FirebaseModel {
    
    //properties
    var name:String
    var uri: String // to uri
    var kind:String
    var captured: String// captured image uri
    var rotated: String
    var purchases: [String]
    
    required init?(dict: [String : Any]) {
        guard let name = dict["name"] as? String,
        let uri = dict["uri"] as? String,
        let kind = dict["kind"] as? String, let captured = dict["captured"] as? String, let rotated = dict["rotated"] as? String, let purchases = dict["purchases"] as? [String]
            else{
                print("video is nil")
                return nil}
        
        self.name = name
        self.uri = uri
        self.kind = kind
        self.captured = captured
        self.rotated = rotated
        self.purchases = purchases
    }
    
    var dict: [String : Any]{
        let dict = ["name" : name,
                    "uri" : uri,
                    "kind": kind,
                    "captured": captured, "rotated": rotated, "purchases": purchases] as [String:Any]
        
        return dict
    }
    
}
