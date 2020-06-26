//
//  Router.swift
//  CoachyFitApp
//
//  Created by Mac on 14/05/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn

//determin root view  controller of our app (Login Or Chat)
class Router{
    
    //properties
    //the app main window (window show viewcontrollers)
    weak var window: UIWindow? //window show login /chat
    
    //is the user logged in or not
    var isLoggedIn:Bool{
        return Auth.auth().currentUser != nil //TODO use firebase login to decide
    }
    
    var isCoach = false
    
    static let shared = Router()
    
    private init(){}
    
    
    func chooseMainViewController(){
        //make sure that we are on the ui thread
        
        //only the uiThread may change viewControllers
        guard Thread.current.isMainThread else {
            //call this method again on the ui thread
            DispatchQueue.main.async {[weak self] in
                self?.chooseMainViewController()
            }
            return
        }
        
        
        //now we are on the uiThread
        let fileName = isLoggedIn ? "Main" : "Intro"
        let sb = UIStoryboard(name: fileName, bundle: Bundle.main)
        
        
        window?.rootViewController = sb.instantiateInitialViewController()
        
    }
    
    
    
}

