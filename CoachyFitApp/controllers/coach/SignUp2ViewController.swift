//
//  SignUp2ViewController.swift
//  CoachyFitApp
//
//  Created by Mac on 17/05/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import AVKit
import Firebase
import FirebaseStorage
import MobileCoreServices
import GoogleSignIn
import FBSDKLoginKit
import Alamofire

class SignUp2ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {

    var rotated = CGFloat(0)
    @IBAction func rotateRighte(_ sender: UIButton) {
        rotated = rotated + .pi / 2
        videoUploaded.transform = CGAffineTransform(rotationAngle: rotated)
        videoUploaded.transform = videoUploaded.transform.rotated(by: CGFloat(rotated))
    }
    @IBOutlet weak var rotateRightOutlet: UIButton!
    @IBAction func rotateLeft(_ sender: UIButton) {
        rotated = rotated - .pi / 2
        videoUploaded.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
    }
    @IBOutlet weak var rotateLeftOutlet: UIButton!
    @IBOutlet weak var profileImageProgressBar: UIProgressView!
    @IBOutlet weak var diplomaProgressBar: UIProgressView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var videoTypePicker: UIPickerView!
    @IBOutlet weak var videoUploaded: UIImageView!
    @IBOutlet weak var diplomaImage: UIImageView!
    @IBOutlet weak var videoName: UITextField!
    @IBOutlet var contentView: UIView!
    
    @IBAction func btnDone(_ sender: UIButton) {
        
        if checkIfFinishMedia() {

            self.coach.diploma = diplomaURL
            self.coach.profileImage = profileURL
        
            Coach.ref.child(coach.id).setValue(self.coach.dict) { (err, db) in
                        if err != nil {
                            print(err!)
                        }
                        print("coach succesfully added")
                        
                    }
                //send bach the new coach for the main screen
            Router.shared.chooseMainViewController()
        }
        
                
    }
    

    var videoType = "type"
    var player: AVPlayer!
    var isProfileChanged = false
    var expertiesPicker = ["TRX","CrossFit","גומיות","פונקציונלי","פילאטיס","יוגה","אירובי","בטן","אחר"]
    
    
        fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
            return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
        }
    
    
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
    
    
    
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return expertiesPicker.count
        }
    
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
            return expertiesPicker[row]
    
        }
    
    
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
        }

    
    var coach = Coach(id: "", fullName: "", age: "", description: "", seniority: "", phone: "", gender: "", profileImage: "", diploma: "", video: [], specialize: [])
    
    
    var profileURL = ""
    var diplomaURL = ""
    var video = [String:Any]()
    var capturedData = Data()
    //boolean parameters
    var isprofileUploaded = false
    var isVideoUploaded = false
    var isDiplomaUploaded = false
    
    var isProfileTappped = false
    var isDiplomaTapped = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
                 
        profileImageProgressBar.progress = 0
        diplomaProgressBar.progress = 0
        
        
        self.videoTypePicker.dataSource = self
        self.videoTypePicker.delegate = self
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizerDiploma = UITapGestureRecognizer(target: self, action: #selector(diplomaTapped(tapGestureRecognizer:)))
        diplomaImage.isUserInteractionEnabled = true
        diplomaImage.addGestureRecognizer(tapGestureRecognizerDiploma)
        
        let tapGestureRecognizerVideo = UITapGestureRecognizer(target: self, action: #selector(videoTapped(tapGestureRecognizer:)))
        videoUploaded.isUserInteractionEnabled = true
        videoUploaded.addGestureRecognizer(tapGestureRecognizerVideo)
        
    }
    
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        AppUtility.lockOrientation(.portrait)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        AppUtility.lockOrientation(.all)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        isProfileTappped = true
        _ = tapGestureRecognizer.view as! UIImageView

        // Your action
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum, type: "image")
    }
    
    @objc func diplomaTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        isDiplomaTapped = true
        _ = tapGestureRecognizer.view as! UIImageView

        // Your action
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum, type: "image")
    }
    
    @objc func videoTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView

                // Your action
                if self.videoName.text != ""{
                VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum, type: "video")
                }else {
                
                    let alert = UIAlertController(title: "לא תקין", message: "אנא הכנס שם לסרטון", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "הבנתי", style: .default, handler: {[weak self] (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                  
                    present(alert, animated: true)

                }

    }
    
    func checkIfFinishMedia() -> Bool{

        if isVideoUploaded == true && isDiplomaUploaded == true && isprofileUploaded == true{
            return true
        }
        showLabel(title: "Must upload everything")
        return false
    }


}

extension SignUp2ViewController: UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

  
    
    if let mediaType = info[.mediaType] ,
        mediaType as! String   == (kUTTypeMovie as String) ,
        let url = info[.mediaURL] as? NSURL
       {

        
        self.videoType = expertiesPicker[videoTypePicker.selectedRow(inComponent: 0)]
        
        let storageRef = Storage.storage().reference().child("coaches").child(Auth.auth().currentUser!.uid).child("videos").child(videoName.text ?? coach.fullName + "s video")

        showProgress(title: "אנא המתן", subtitle: "הסרטון עולה, תהליך זה עלול לקחת כמה רגעים")
        
        guard let storageURL = url.absoluteURL
            else {
            print("not the right converter")
            return}
        
        let task = storageRef.putFile(from: storageURL   , metadata: nil) {[weak self] (metadata, error) in
        if error != nil{
            print("error uploading", error)
        }

            storageRef.downloadURL { (url, error) in
                if error != nil {
                    print(error)
                }
                guard let url = url else {
                    print(error)
                    return
                }
                guard let strongSelf = self else {return }
                let videoUrl = url as NSURL
                strongSelf.video = ["kind": strongSelf.videoType, "name": self?.videoName.text, "uri": videoUrl.absoluteString, "captured": "", "rotated": "0"]
//                    videoUrl.absoluteString!
                strongSelf.coach.video.append(strongSelf.video)
               
                
                captureImage(fileUrl: url, videoImage: strongSelf.videoUploaded!, progressBar: nil, rotateleft: strongSelf.rotateLeftOutlet, rotateright: strongSelf.rotateRightOutlet)
                guard let capturedData = captureImageToFirebase(videoUrl: url) else {return}
                print(capturedData)
                
                strongSelf.capturedData = capturedData
               
      
                let captureID = String(decoding: strongSelf.capturedData, as: UTF8.self)
                let storRef = Storage.storage().reference().child("coaches").child(Auth.auth().currentUser!.uid).child("captures").child(strongSelf.coach.video[0]["name"] as! String + "_captured" )
                _ = URL(fileURLWithPath: captureID)
                _ = storRef.putData( strongSelf.capturedData , metadata: nil) { (metadata, err) in
                           if err != nil {
                               print(err)
                           }
                           storRef.downloadURL { (capurl, error) in
                          
                         
                               if error != nil {
                                   print(error)
                               }
                            if strongSelf.coach.video.count > 0 {
                                guard capurl != nil else {print("captured returned nil")
                                                             return
                                                         }
                                strongSelf.coach.video[0]["captured"] = capurl!.absoluteString
                             
                                strongSelf.isVideoUploaded = true
                            }
                           }
                       }
                  }
                }
    }
    else if let _ = info[.editedImage], let url = info[.imageURL] as? NSURL{

        if self.isProfileTappped{
        
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
                    strongSelf.isprofileUploaded = true
                        strongSelf.isProfileTappped = false
                        
                        DispatchQueue.global(qos: .userInteractive).async {
                                                AF.request(profileurl).downloadProgress(closure: { (progress)in
                                                    strongSelf.profileImageProgressBar.progress = Float(progress.fractionCompleted)
                                                    }).response { (response) in
                                                            DispatchQueue.main.async {
                                                                strongSelf.profileImage.image = profile
                                                        }
                                                        strongSelf.profileImageProgressBar.isHidden = true
                                                   }
                                               }
               }catch let e {
                print(e, "error uploading profile")
                        
                }
            }
            }
           
            
        }else if self.isDiplomaTapped {
          
            let storageRef =  Storage.storage().reference().child("coaches").child(Auth.auth().currentUser!.uid).child("diplomas").child("diploma")


                  storageRef.putFile(from: url as URL , metadata: nil){ [weak self] (metadata, error) in
                      if error != nil {
                          print(error)
                      }
                      storageRef.downloadURL { (url, error) in
                         do{
                              let data = try Data(contentsOf: url!)
                          guard let strongSelf = self else  {return}
                        let diploma = UIImage(data: data)
                            let diplomaurl = url!
                        strongSelf.diplomaURL = diplomaurl.absoluteString
                        strongSelf.isDiplomaUploaded = true
                        strongSelf.isDiplomaTapped = false
                        DispatchQueue.global(qos: .userInteractive).async {
                         AF.request(diplomaurl).downloadProgress(closure: { (progress)in
                             strongSelf.diplomaProgressBar.progress = Float(progress.fractionCompleted)
                             }).response { (response) in
                                     DispatchQueue.main.async {
                                         strongSelf.diplomaImage.image = diploma
                                 }
                                 strongSelf.diplomaProgressBar.isHidden = true
                            }
                        }
                        
                    }catch let err{
                    print(err)
                }
            }
        }
               
    }




      
        
    }

      dismiss(animated: true) {

      }
    

    
}
}
