//
//  User.swift
//  CoachyFitApp
//
//  Created by Mac on 17/05/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import FirebaseAuth

struct User: Codable{
    var isCoach = false
    var needsMoreDetails = true
    var id: String
    var name: String
    var isLoggedIn = false
    
    //userDefaults
    var coachDetails: Coach?{
        if isCoach == true{
            let coach = Coach(id: Auth.auth().currentUser!.uid, fullName: name, age: "", description: "",seniority: "", phone: "", gender: "", profileImage: "", diploma: "", video: [], specialize: [""])
            
            
            return coach
        }
        return nil
    }
    
}



    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let defaults = UserDefaults.standard

    //func loadFromDefaults()->User
    var loadUser:User?{
        if let savedPerson = defaults.object(forKey: "user") as? Data {
            if let loadedPerson = try? decoder.decode(User.self, from: savedPerson) {
                return loadedPerson
            }
        }
        return nil
    }
    //func saveToDefaults()->
    func saveUserToDefaults(_ user: User){
        if let encoded = try? encoder.encode(user) {
            defaults.set(encoded, forKey: "user")
        }
    }



    //delete? ->


// all users are clients and they can upgrade themselves to Coach
//TODO: save the user locally(UserDefaults or coredata)  and to firebase
