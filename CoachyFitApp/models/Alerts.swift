//
//  Alerts.swift
//  CoachyFitApp
//
//  Created by Mac on 15/06/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation

class Allert{
    static let shared = Allert()
    private init(){}
    
    func getAlert(title:String, message: String){
        let alert = UIAlertController(title: "רכישת סרטון אימון", message: "האם ברצונך לרכוש סרטון אימון זה?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "כן", style: .default, handler: { (action) in
            let videoString = self.coach.video[indexPath.item]["uri"]
            let videoUrl = URL(string: videoString as! String)

            let player = AVPlayer(url: videoUrl!)
            let vcPlayer = AVPlayerViewController()
            vcPlayer.player = player
            self.present(vcPlayer, animated: true, completion: nil)
        }))
        
        //add another button
        alert.addAction(.init(title: "לא", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true)
    }
}
