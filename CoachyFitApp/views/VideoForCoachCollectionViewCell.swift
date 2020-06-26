//
//  VideoForCoachCollectionViewCell.swift
//  CoachyFitApp
//
//  Created by Mac on 29/05/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Firebase

protocol DataCollectionProtocol {
    func deleteData(indexPath: IndexPath)
}

class VideoForCoachCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var deleteOutlet: UIButton!
    @IBOutlet weak var clickIcon: UIImageViewX!
    @IBOutlet weak var coachVideoName: UILabel!
    @IBOutlet weak var coachVideos: UIImageView!
    @IBOutlet weak var faded: UIVisualEffectView!
    

    var delegate:DataCollectionProtocol?
    var index: IndexPath?
    
    @IBAction func btnDelete(_ sender: UIButton) {
        delegate?.deleteData(indexPath: index!)
    }

    
    func populate(coach: Coach, indexPath: IndexPath) {
        let firstVideos = coach.getFirstVideos(coach: coach)
        let allvideos = coach.fillAllVideosFirst()
        
        if indexPath.item > firstVideos.count - 1 {
            let purchases = allvideos[indexPath.item]["purchases"] as! [String]
            if purchases.contains(Auth.auth().currentUser!.uid) {
                faded.isHidden = true
                  clickIcon.image = #imageLiteral(resourceName: "icons8-circled_play")
            }else {
            faded.isHidden = false
            clickIcon.image = #imageLiteral(resourceName: "icons8-lock-1")
            }
        }else {
            faded.isHidden = true
            clickIcon.image = #imageLiteral(resourceName: "icons8-circled_play")
        }
           
        if coachVideoName.text!.count < 25{
            coachVideoName.text = (allvideos[indexPath.item]["name"] as! String)
        }else{
            
        }
                           
        let capRef = Storage.storage().reference().child("coaches").child(coach.id).child("captures").child(allvideos[indexPath.item]["name"] as! String + "_captured")
            coachVideos.sd_setImage(with: capRef)
                           
            //placeholder
            coachVideos.sd_setImage(with: capRef, placeholderImage: #imageLiteral(resourceName: "icons8-full_image"))
                    
        if allvideos[indexPath.item]["rotated"] != nil {
                           if let rotation = NumberFormatter().number(from: allvideos[indexPath.item]["rotated"] as! String) {
                               let CGRotation = CGFloat(truncating: rotation)
                               coachVideos.transform = CGAffineTransform(rotationAngle: CGRotation)
                           }
                       }
                
        faded.layer.cornerRadius = 10
        
       
    }
    
    func populateForCoach(coach: Coach, indexPath: IndexPath, isEditing: Bool, title: String) {
        if isEditing{
            deleteOutlet.isHidden = false
        }
        else {
            deleteOutlet.isHidden = true
        }
        let a = coach.video[indexPath.item]["name"] as! String
        coachVideoName.text = a
        
        if coach.getFirstVideoOfKind(Kind: title)["rotated"] != nil {
                           if let rotation = NumberFormatter().number(from: coach.getFirstVideoOfKind(Kind: title)["rotated"] as! String) {
                            let CGRotation = CGFloat(truncating: rotation)
                            coachVideos.transform = CGAffineTransform(rotationAngle: CGRotation)
                        }
                    }
        
        let capRef = Storage.storage().reference().child("coaches").child(coach.id).child("captures").child(a + "_captured")
        coachVideos.sd_setImage(with: capRef)
        
        //placeholder
        coachVideos.sd_setImage(with: capRef, placeholderImage: #imageLiteral(resourceName: "icons8-full_image"))
    }
    
}
