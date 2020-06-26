//
//  CoustumLSViewController.swift
//  CoachyFitApp
//
//  Created by Mac on 19/05/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class CoustumLSViewController: UIViewController {

    
    var coaches = [Coach]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sb = UIStoryboard(name: "Main", bundle: .main)
        
        
        
        let nc = sb.instantiateViewController(withIdentifier: "TrainingNavigation") as? UINavigationController
        let vc = nc?.viewControllers.first as? TrainingTypesTableViewController
        
        

        //read from firebase
        Coach.ref.observe(.childAdded) {[weak self] (snapshot) in
        
            guard let dict = snapshot.value! as? [String:Any], let coach = Coach(dict: dict) else{return}
           
            self?.coaches.append(coach)
        
            print(self?.coaches)
//            vc?.coaches = self?.coaches as! [Coach]
        
        }
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
        
    

}
