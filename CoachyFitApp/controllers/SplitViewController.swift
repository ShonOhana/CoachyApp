//
//  SplitViewController.swift
//  CoachyFitApp
//
//  Created by Mac on 14/05/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // side by side in landScape
        preferredDisplayMode = .allVisible
    
        
        //in portrait when we start -> details
        delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary    secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool    {
        return true //always start in the master
    }

}
