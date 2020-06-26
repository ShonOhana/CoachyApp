//
//  CoachForClientViewController.swift
//  CoachyFitApp
//
//  Created by Mac on 30/05/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Firebase
import AVKit

class CoachForClientViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coach.fillAllVideosFirst().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VideoForCoachCollectionViewCell
        
        cell.populate(coach: coach, indexPath: indexPath)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         
            if indexPath.item < coach.getFirstVideos(coach: coach).count{
                let videoString = coach.video[indexPath.item]["uri"]
               let videoUrl = URL(string: videoString as! String)

               let player = AVPlayer(url: videoUrl!)
               let vcPlayer = AVPlayerViewController()
               vcPlayer.player = player
               self.present(vcPlayer, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "רכישת סרטון אימון", message: "האם ברצונך לרכוש סרטון אימון זה?", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "כן", style: .default, handler: {(action) in
                    var purchases = self.coach.video[indexPath.item]["purchases"] as! [String]
                    if purchases[0] == ""{
                        purchases[0] = Auth.auth().currentUser!.uid
                    }else {
                    purchases.append(Auth.auth().currentUser!.uid)
                    }
                    self.coach.video[indexPath.item]["purchases"] = purchases
                    let ref = Database.database().reference().child("coaches").child((self.coach.id)).child("video").child(indexPath.item.description)
                    ref.setValue(self.coach.video[indexPath.item])
                    
                    collectionView.reloadData()
                    
                    let videoString = self.coach.video[indexPath.item]["uri"]
                    let videoUrl = URL(string: videoString as! String)

                    let player = AVPlayer(url: videoUrl!)
                    let vcPlayer = AVPlayerViewController()
                    vcPlayer.player = player
                    self.present(vcPlayer, animated: true, completion: nil)
//                    collectionView.reloadItems(at: [indexPath])
                }))
                
                //add another button
                alert.addAction(.init(title: "לא", style: .cancel, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                present(alert, animated: true)
        }
        
        
    }
    
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var diplomaImageView: UIImageView!
    @IBOutlet weak var coachDiploma: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var diplomaDialog: UIView!
    var videoCell = UICollectionViewCell()
    var scaleHeight : CGFloat = 0.0
    var scaleWidth : CGFloat = 0.0


    func addImageDialog(dialog: UIView, url: String){
            self.view.addSubview(dialog)
            dialog.translatesAutoresizingMaskIntoConstraints = false
            if dialog.isDescendant(of: self.view){
                            
                background.isHidden = false
                UIView.animate(withDuration: 0.5, animations: {
               
                
                dialog.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
                dialog.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
                 self.coachDiploma.transform = CGAffineTransform(scaleX: self.scaleWidth  , y: self.scaleHeight)
                let diplomaUrl = URL(string: url )
                self.coachDiploma.sd_setImage(with: diplomaUrl)
                
            }) { (done) in
                self.collectionView.isUserInteractionEnabled = false
               
                self.coachDiploma.transform = CGAffineTransform(scaleX: self.scaleWidth  , y: self.scaleHeight)
          
            }
            }else  {
                print("something went wrong")
                addImageDialog(dialog: dialog, url: url)
            }
        }


    
    var videosArray = [[String:Any]]()
    
    //property
    var coach = Coach(id: "", fullName: "", age: "", description: "", seniority: "", phone: "", gender: "", profileImage: "", diploma: "", video: [], specialize: [])
    @IBOutlet weak var coachView: CoachView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scaleHeight = self.view.frame.height / self.coachDiploma.frame.height - 1
        self.scaleWidth = self.view.frame.width / self.coachDiploma.frame.width - 1
        diplomaImageView.isUserInteractionEnabled = true
        

        let tap = UITapGestureRecognizer(target: self, action: #selector(diplomaTapEdit(sender:)))
        diplomaImageView.addGestureRecognizer(tap)
        
        let tapProfile = UITapGestureRecognizer(target: self, action: #selector(profileTapEdit(sender:)))
        coachView.coachProfileImage.isUserInteractionEnabled = true
        coachView.coachProfileImage.addGestureRecognizer(tapProfile)
        
        collectionView.reloadData()
        
        gotIt()
    }
    
    @objc func diplomaTapEdit(sender: UITapGestureRecognizer){
        addImageDialog(dialog: diplomaDialog, url: self.coach.diploma!)
    }
    @objc func profileTapEdit(sender: UITapGestureRecognizer){
        addImageDialog(dialog: diplomaDialog, url: self.coach.profileImage!)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        UIView.setAnimationsEnabled(false)
//        self.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
//        UIView.setAnimationsEnabled(true)
//    }
//    
//     override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        AppUtility.lockOrientation(.portrait)
//
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        AppUtility.lockOrientation(.all)
//    }
//    
//      override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if diplomaDialog.isDescendant(of: self.view){
        dismissDialog(dialog: self.diplomaDialog)
        }
    }
    
    func dismissDialog(dialog: UIView){
        dialog.removeFromSuperview()
        
        self.collectionView.isUserInteractionEnabled = true
        background.isHidden = true
    }
    
    func gotIt(){
        descriptionLabel.text = coach.description
        
        coachView.ageLabel.text = getAgeFromDOF(date: coach.age).description
        
        coachView.coachNameLabel.text = coach.fullName
        coachView.seniorityLabel.text = getSeniorityYear(date: coach.seniority).description
        var specilized = ""
        for i in coach.specialize{
            if i != "אחר"{
                specilized.append("\(i) ")
            }
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
            diplomaImageView.sd_setImage(with: diplomaRef)
            
        //placeholder
        coachDiploma.sd_setImage(with: diplomaRef, placeholderImage: #imageLiteral(resourceName: "coachyWbg"))
        }else{
        coachDiploma.image = #imageLiteral(resourceName: "coachy_logo")
        }
        
    }
    
}
