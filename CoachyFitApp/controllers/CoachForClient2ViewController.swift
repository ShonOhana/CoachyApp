//
//  CoachForClient2ViewController.swift
//  CoachyFitApp
//
//  Created by Mac on 30/05/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Firebase

class CoachForClient2ViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coach.video.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VideoForCoachCollectionViewCell
        
        cell.populate(coach: coach, indexPath: indexPath)
        
        return cell
    }
    
    @IBOutlet weak var diplomaImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var videosArray = [[String: Any]]()
    
    //property
    var coach = Coach(id: "", fullName: "", age: "", description: "", seniority: "", phone: "", gender: "", profileImage: "", diploma: "", video: [], specialize: [])
    
    @IBOutlet weak var coachView: CoachView!
    override func viewDidLoad() {
        super.viewDidLoad()
                
        gotIt()
        
        collectionView.reloadData()
    }
    
    func gotIt(){
        
        coachView.coachNameLabel.text = coach.fullName
        coachView.ageLabel.text = getAgeFromDOF(date: coach.age).description
        coachView.seniorityLabel.text = getSeniorityYear(date: coach.seniority).description
        var specilized = ""
        for i in coach.specialize{
            specilized += "\(i), "
        }
        coachView.specializeLabel.text = "\(specilized)"
        
        let ref = Storage.storage().reference().child("coaches").child(coach.id).child("profileImages").child("profileImage")
        if let _ = coach.profileImage{
            coachView.coachProfileImage.sd_setImage(with: ref)
            
        //placeholder
        coachView.coachProfileImage.sd_setImage(with: ref, placeholderImage: #imageLiteral(resourceName: "coachyWbg"))
        }else{
        coachView.coachProfileImage.image = #imageLiteral(resourceName: "coachy_logo")
        }
        coachView.coachProfileImage.layer.cornerRadius = coachView.coachProfileImage.frame.size.width / 2
        coachView.coachProfileImage.clipsToBounds = true
        
        
        let diplomaRef = Storage.storage().reference().child("coaches").child(coach.id).child("diplomas").child("diploma")
        if let _ = coach.diploma{
            diplomaImage.sd_setImage(with: diplomaRef)
            
        //placeholder
        diplomaImage.sd_setImage(with: diplomaRef, placeholderImage: #imageLiteral(resourceName: "coachyWbg"))
        }else{
        diplomaImage.image = #imageLiteral(resourceName: "coachy_logo")
        }
        
        
    }

}

