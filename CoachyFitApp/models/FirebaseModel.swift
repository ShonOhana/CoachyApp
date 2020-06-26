//
//  FirebaseModel.swift
//  CoachyFitApp
//
//  Created by Mac on 14/05/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation

protocol FirebaseModel {
    //from json
    init?(dict: [String:Any])
    //to json
    var dict: [String:Any] {get}
}
