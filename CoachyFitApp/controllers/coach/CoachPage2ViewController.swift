//
//  CoachPage2ViewController.swift
//  CoachyFitApp
//
//  Created by Mac on 14/05/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import AVKit
import Firebase

class CoachPage2ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //properties
    var coach = Coach(id: "", fullName: "", age: "", description: "", seniority: "", phone: "", gender: "", profileImage: "", diploma: "", video: [], specialize: [])
    
    
    @IBOutlet weak var coachView: CoachView!
    
    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var coachDiploma: UIImageView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoCollectionView.reloadData()

                coachView.coachProfileImage.layer.cornerRadius = coachView.coachProfileImage.frame.size.width / 2
                coachView.coachProfileImage.clipsToBounds = true
                
        readFromDB()
                
                
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        coach.video.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let cell = videoCollectionView.dequeueReusableCell(withReuseIdentifier: "coachVideos", for: indexPath) as! VideoForCoachCollectionViewCell
//
        cell.populate(coach: coach, indexPath: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoString = coach.video[indexPath.item]["uri"]
                let videoUrl = URL(string: videoString as! String)

                let player = AVPlayer(url: videoUrl!)
                let vcPlayer = AVPlayerViewController()
                vcPlayer.player = player
                self.present(vcPlayer, animated: true, completion: nil)
    }

    func readFromDB(){
        guard let id = Auth.auth().currentUser?.uid else {return}
                coach.id = id
                
                    let ref  = Database.database().reference().child("coaches").child(id)
                    ref.observeSingleEvent(of: .value) {[weak self] (snapshot) in
                        if snapshot.exists(){
                            let read = snapshot.value as? [String : Any] ?? [:]
                            self?.coach.fullName = (read["name"] as! String)
                            self?.coach.age = (read["age"] as! String)
                            self?.coach.description = (read["description"] as! String)
                            self?.coach.phone = (read["phone"] as! String)
                            self?.coach.seniority = (read["seniority"] as! String)
                            self?.coach.specialize = (read["specialize"] as? [String] ?? [])
                            
  
                            
                            let ref = Storage.storage().reference().child("coaches").child((self?.coach.id)!).child("profileImages").child("profileImage")
                            
                                
                            if let _ = self?.coach.profileImage{
                                self?.coachView.coachProfileImage.sd_setImage(with: ref)
                                    
                                    //placeholder
                                self?.coachView.coachProfileImage.sd_setImage(with: ref, placeholderImage: #imageLiteral(resourceName: "icons8-full_image"))
                                }else{
                                    self?.coachView.coachProfileImage.image = #imageLiteral(resourceName: "coachy_logo")
                                }
                            
                            self?.coachView.coachNameLabel.text = self?.coach.fullName
                            self?.coachView.seniorityLabel.text = getSeniorityYear(date: (self?.coach.seniority)!).description
                            self?.coachView.ageLabel.text = getAgeFromDOF(date: (self?.coach.age)!).description
                            var specilized = [String]()
                            for specialize in (self?.coach.specialize)!{
                                specilized.append(specialize)
                            }
                            
                             self?.coachView.specializeLabel.text = "\(specilized)"
                    }
                }
            }
}
