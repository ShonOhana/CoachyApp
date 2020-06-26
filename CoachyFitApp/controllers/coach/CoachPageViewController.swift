//
//  CoachPageViewController.swift
//  CoachyFitApp
//
//  Created by Mac on 14/05/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Firebase
import AVKit


class CoachPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate {
    
        @IBOutlet weak var videoCollectionView: UICollectionView!
        
        //property
    var coach = Coach(id: "", fullName: "", age: "", description: "", seniority: "", phone: "", gender: "", profileImage: "", diploma: "", video: [], specialize: [])
    var videoCell = UICollectionViewCell()
        
    var videoArray = [Dictionary<String, Any>]()
    var profileURL = ""
    var diplomaUrl = ""
    var isDiplomaTapped = false
    var isProfileTapped = false
    var isEditingVideos = false

    @IBOutlet weak var noVidsLabel: UILabelX!
    @IBOutlet weak var editingVideoOutlet: UIButton!
    @IBOutlet weak var coachDiploma: UIImageView!
    @IBOutlet weak var coachView: CoachView!
    @IBOutlet weak var coachDescription: UILabel!

    // add another video
    @IBAction func addVideo(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "AddVideoViewController") as? AddVideoViewController else {return}

            
            vc.coach = self.coach
            self.navigationController?.pushViewController(vc, animated: true)

        }
    
    @IBAction func editVideos(_ sender: UIButton) {
        if !isEditingVideos{
            self.editingVideoOutlet.setTitle("סיום", for: .normal)
            isEditingVideos = true
           
        }
        else {
            self.editingVideoOutlet.setTitle("ערוך סרטונים", for: .normal)
            isEditingVideos = false
        }
         self.videoCollectionView.reloadData()
    }
    
    
    


    func showAlert(coach: Coach,label: UILabel, text: String){
        
        if coach.video.count == 0 {
                for i in text{
                    label.backgroundColor = .lightGray
                    label.text! += "\(i)"
                    RunLoop.current.run(until: Date() + 0.15)
                }

        }
    }

        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            
            coachView.coachProfileImage.isUserInteractionEnabled = true
            
                    let tap = UITapGestureRecognizer(target: self, action: #selector(profileTapEdit(sender:)))
                    coachView.coachProfileImage.addGestureRecognizer(tap)
            
            coachDiploma.isUserInteractionEnabled = true
            
                    let tapDiploma = UITapGestureRecognizer(target: self, action: #selector(diplomaTapEdit(sender:)))
                    coachDiploma.addGestureRecognizer(tapDiploma)
        
            
            coachView.coachProfileImage.layer.cornerRadius = coachView.coachProfileImage.frame.size.width / 2
            coachView.coachProfileImage.clipsToBounds = true
            
            readFromDB()
            
            
            videoCollectionView.reloadData()
            
            
                        
        }
    
    @objc func profileTapEdit(sender: UITapGestureRecognizer){
        isProfileTapped = true

        _ = sender.view as! UIImageView

        // Your action
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum, type: "image")
    }
    @objc func diplomaTapEdit(sender: UITapGestureRecognizer){
        _ = sender.view as! UIImageView

        isDiplomaTapped = true

        // Your action
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum, type: "image")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        noVidsLabel.text = ""
        showAlert(coach: coach, label: noVidsLabel, text: "כדי שתוצג באפליקציה, אנא עלה סרטון אימון")
    }
    
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        AppUtility.lockOrientation(.portrait)
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        AppUtility.lockOrientation(.all)
    }
    
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return coach.fillAllVideosFirst().count
            
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = videoCollectionView.dequeueReusableCell(withReuseIdentifier: "coachVideos1", for: indexPath) as! VideoForCoachCollectionViewCell

            cell.populateForCoach(coach: coach, indexPath: indexPath, isEditing: self.isEditingVideos, title: coach.video[0]["kind"] as! String)
            
            cell.index = indexPath
            cell.delegate = self
            
        
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
                        self?.coach.video = (read["video"] as? [Dictionary <String,Any>] ?? [])
                        self?.videoArray = self?.coach.video as! [Dictionary<String, Any>]
                        self?.coach.specialize = (read["specialize"] as? [String] ?? [])
                        
                        if self?.coach.video.count == 0 {
                            self?.editingVideoOutlet.isEnabled = false
                        }else {
                            self?.editingVideoOutlet.isEnabled = true
                        }
                    
                      if let _ = self?.coach.profileImage{

                            let imageString = read["profileImage"] as! String
                        self?.coach.profileImage = imageString
                        if self?.coach.profileImage != ""{
                            let imageUrl = NSURL(string: imageString)
                                self?.coachView.coachProfileImage.sd_setImage(with:imageUrl! as URL, completed: { (image, err,cacheType, url) in
                                    if err != nil{
                                    print(err)
                                    }
                                    print(url)
                                    print(cacheType)
                                })
                                    }else{
                                    self?.coachView.coachProfileImage.image = #imageLiteral(resourceName: "באנר העלאת תמונת פרופיל")
                                }
                        
                            if let _ = self?.coach.diploma{
                                let diplomaString = read["diploma"] as! String
                                self?.coach.diploma = diplomaString
                                if self?.coach.diploma != "" {
                                    
                                    let diplomaUrl = NSURL(string: diplomaString)
                                    self?.coachDiploma.sd_setImage(with:diplomaUrl! as URL, completed: { (image, err,cacheType, url) in
                                        if err != nil{
                                        print(err)
                                        }
                                        print(url)
                                        print(cacheType)
                                    })
                                }}else{
                                    self?.coachDiploma.image = #imageLiteral(resourceName: "Green and White Tea and Cakes Logo (2)")
                                }
                                
                        }
                            
                        }else{
                            self?.coachDiploma.image = #imageLiteral(resourceName: "Green and White Tea and Cakes Logo (2)")
                        }
                        
                        
                        self?.coachView.coachNameLabel.text = self?.coach.fullName
                        self?.coachView.seniorityLabel.text = getSeniorityYear(date: (self?.coach.seniority)!).description
                        self?.coachView.ageLabel.text = getAgeFromDOF(date: (self?.coach.age)!).description
                        var specilized = ""
                        for i in (self?.coach.specialize)!{
                            if i != "אחר"{
                                specilized.append("\(i) ")
                            }
                        }
                        self?.coachView.specializeLabel.text = "\(specilized)"
                        self?.coachDescription.text = self?.coach.description
                        
                        guard let strongSelf = self else{return}
                        //tell the tableview: (insert row)
                        let path = IndexPath(row: strongSelf.coach.video.count - 1, section: 0)
                        
                        self?.videoCollectionView.insertItems(at: [path])
                }
            }
        


}

extension CoachPageViewController: DataCollectionProtocol{
    func deleteData(indexPath: IndexPath) {
        let alert = UIAlertController(title: "מחיקת סרטון", message: "האם אתה בטוח שברצונך למחוק סרטון זה?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "כן", style: .default, handler: {[weak self] (action) in
           self?.coach.video.remove(at: indexPath.item)
            self?.videoArray.remove(at: indexPath.item)
            let ref = Coach.ref.child((self?.coach.id)!).child("video")
        
            ref.child(indexPath.item.description).removeValue()

            ref.setValue(self?.videoArray)
            self?.videoCollectionView.reloadData()
        }))
        
        //add another button
        alert.addAction(.init(title: "לא", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true)
       
    }
    
}

extension CoachPageViewController: UIImagePickerControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            
            if let mediaType = info[.editedImage], let url = info[.imageURL] as? NSURL{
                
                if isProfileTapped{
                    let storageRef =  Storage.storage().reference().child("coaches").child(Auth.auth().currentUser!.uid).child("profileImages").child("profileImage")

                
                storageRef.putFile(from: url as URL , metadata: nil){ [weak self] (metadata, error) in
                    if error != nil {
                        print(error)
                    }
                    storageRef.downloadURL { (url, error) in
                       do{
                            let data = try Data(contentsOf: url!)
                        guard let strongSelf = self else  {return}
                            
                            let profile = UIImage(data: data)
                                let profileurl = url!
                        strongSelf.profileURL = profileurl.absoluteString
 
                        
                        Coach.ref.child((self?.coach.id)!).child("profileImage").setValue(self?.profileURL)
                        
                        self?.showSuccess(title: "תמונת הפרופיל שונתה בהצלחה", subtitle: nil)
                        
                        self?.coachView.coachProfileImage.image = profile

                        
                       }catch let e {
                        self?.showError(title: "משהו השתבש, אנא נסה שנית", subtitle: nil)
                                
                        }
                    }
             }
                    isProfileTapped = false
            
                } else if isDiplomaTapped{
                    let diplomaRef =  Storage.storage().reference().child("coaches").child(Auth.auth().currentUser!.uid).child("diplomas").child("diploma")

                                              
                                              diplomaRef.putFile(from: url as URL , metadata: nil){ [weak self] (metadata, error) in
                                                  if error != nil {
                                                      print(error)
                                                  }
                                                  diplomaRef.downloadURL { (url, error) in
                                                     do{
                                                        self?.showProgress()
                                                          let data = try Data(contentsOf: url!)
                                                      guard let strongSelf = self else  {return}
                                                          
                                                          let diploma = UIImage(data: data)
                                                              let diplomaurl = url!
                                                      strongSelf.diplomaUrl = diplomaurl.absoluteString
                               
                                                      
                                                      Coach.ref.child((self?.coach.id)!).child("diploma").setValue(self?.diplomaUrl)
                                                      
                                                        self?.showSuccess(title: "תעודת ההסמכה עודכנה בהצלחה", subtitle: nil)
                                                        
                                                       self?.coachDiploma.image = diploma

                                                      
                                                     }catch let e {
                                                        self?.showError(title: "משהו השתבש, אנא נסה שנית", subtitle: nil)
                                                              
                                                      }
                                                  }
                                           }
                                          
                    isDiplomaTapped = false

                                          }
                               
                }

//            }
            
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
