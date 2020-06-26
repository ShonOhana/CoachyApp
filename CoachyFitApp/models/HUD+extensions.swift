//
//  HUD+extensions.swift
//  CoachyFitApp
//
//  Created by Mac on 14/05/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import PKHUD

protocol ShowHUD {
    //abstract methods
}

//add concrete methods to your protocol
extension ShowHUD{
    func showProgress(title: String? = nil, subtitle: String? = nil){
        HUD.show(.labeledProgress(title: title, subtitle: subtitle))
    }
    
    func showError(title: String? = nil, subtitle: String? = nil){
        HUD.show(.labeledError(title: title, subtitle: subtitle))
    }
    
    func showLabel(title:String){
        HUD.flash(.label(title), delay: 1)
    }
    
    func showSuccess(title:String? = nil, subtitle: String? = nil){
        HUD.flash(.labeledSuccess(title: title, subtitle: subtitle),delay: 1)
    }
    
}

extension UIViewController:ShowHUD{}
