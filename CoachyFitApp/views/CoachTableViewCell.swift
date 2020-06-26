//
//  CoachTableViewCell.swift
//  CoachyFitApp
//
//  Created by Mac on 14/05/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import SDWebImage
import MobileCoreServices
import FirebaseUI
import AVFoundation

protocol myTableDelegate{
    func coachPageDelegate(_ cell: UITableViewCell)
    func videoDelegate(_ cell: UITableViewCell)
}

class CoachTableViewCell: UITableViewCell {

   
    @IBOutlet weak var coachNameLabel: UILabel!
    @IBOutlet weak var coachProfileImage: UIImageView!
    @IBOutlet weak var coachVideo: UIImageView!
    @IBOutlet weak var specializeLabel: UILabel!
    
    var specilized = ""
    var delegate: myTableDelegate?
    var videoDelegate: myTableDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        coachNameLabel.isUserInteractionEnabled = true
        coachProfileImage.isUserInteractionEnabled = true
        coachVideo.isUserInteractionEnabled = true
        
        //ADD 3 TAP FOR THE CELL
        let tap = UITapGestureRecognizer(target: self, action: #selector(stackTapEdit(sender:)))
        coachNameLabel.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(stackTapEdit(sender:)))
        coachProfileImage.addGestureRecognizer(tap2)
        
        let videoTap = UITapGestureRecognizer(target:self, action:#selector(videoTapEdit(sender:)))
        coachVideo.addGestureRecognizer(videoTap)
        
        
    }

    //OBJC FUNC FOR THE TAP
    @objc func stackTapEdit(sender: UITapGestureRecognizer){
        delegate?.coachPageDelegate(self)
    }
    @objc func videoTapEdit(sender: UITapGestureRecognizer){
        delegate?.videoDelegate(self)
    }
    
    //FUNC THAT INITIALIZE THE DATA FOR EACH COACH
    func populate(with coach: Coach, indexPath: IndexPath, title: String){

        coachNameLabel.text = coach.fullName
        for specialize in coach.specialize{
            if specialize != "אחר"{
                specilized.append("\(specialize) ")
                
            }
            specializeLabel.text = "\(specilized)"
            
        }
        
//        let allvideos = coach.fillAllVideosFirst()
        
        if coach.getFirstVideoOfKind(Kind: title)["rotated"] != nil {
                           if let rotation = NumberFormatter().number(from: coach.getFirstVideoOfKind(Kind: title)["rotated"] as! String) {
                            let CGRotation = CGFloat(truncating: rotation)
                            coachVideo.transform = CGAffineTransform(rotationAngle: CGRotation)
                        }
                    }
        
        
        let ref = Storage.storage().reference().child("coaches").child(coach.id).child("profileImages").child("profileImage")
                
                if let _ = coach.profileImage{
                    coachProfileImage.sd_setImage(with: ref)
                    
                    //placeholder
                    coachProfileImage.sd_setImage(with: ref, placeholderImage: #imageLiteral(resourceName: "יוגה 2"))
                }else{
                    coachProfileImage.image = #imageLiteral(resourceName: "coachy_logo")
                }
                
                    let capRef = Storage.storage().reference().child("coaches").child(coach.id).child("captures").child(coach.getFirstVideoOfKind(Kind: title)["name"] as! String + "_captured")
                    coachVideo.sd_setImage(with: capRef)
                    
                    //placeholder
                    coachVideo.sd_setImage(with: capRef, placeholderImage: #imageLiteral(resourceName: "icons8-full_image"))
  
                    //circle? with the color
                    coachProfileImage.layer.masksToBounds = true //crop the radius
                    coachProfileImage.layer.cornerRadius = coachProfileImage.frame.width / 2
        


    }
    
      func populateForSearch(with coaches: [Coach], indexPath: IndexPath, name: String){

            
            

        for i in 0..<coaches.count{
            if coaches[i].fullName.contains(name.lowercased()){
                coachNameLabel.text = coaches[i].fullName
                for specialize in coaches[i].specialize{
                    if specialize != "אחר"{
                        specilized.append("\(specialize) ")
                        
                    }
                    specializeLabel.text = "\(specilized)"
                    
                    if coaches[i].video[0]["rotated"] != nil {
                                       if let rotation = NumberFormatter().number(from: coaches[i].video[0]["rotated"] as! String) {
                                        let CGRotation = CGFloat(truncating: rotation)
                                        coachVideo.transform = CGAffineTransform(rotationAngle: CGRotation)
                                    }
                                }
                          let ref = Storage.storage().reference().child("coaches").child(coaches[i].id).child("profileImages").child("profileImage")
                                  
                                  if let _ = coaches[i].profileImage{
                                      coachProfileImage.sd_setImage(with: ref)
                                      
                                      //placeholder
                                      coachProfileImage.sd_setImage(with: ref, placeholderImage: #imageLiteral(resourceName: "יוגה 2"))
                                  }else{
                                      coachProfileImage.image = #imageLiteral(resourceName: "coachy_logo")
                                  }
                                  
                                      let capRef = Storage.storage().reference().child("coaches").child(coaches[i].id).child("captures").child(coaches[i].video[0]["name"] as! String + "_captured")
                                      coachVideo.sd_setImage(with: capRef)
                                      
                                      //placeholder
                                      coachVideo.sd_setImage(with: capRef, placeholderImage: #imageLiteral(resourceName: "icons8-full_image"))
                    
                                      //circle? with the color
                                      coachProfileImage.layer.masksToBounds = true //crop the radius
                                      coachProfileImage.layer.cornerRadius = coachProfileImage.frame.width / 2
                }
            }
        }
        
            
        }


    }
