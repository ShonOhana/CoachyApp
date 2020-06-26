//
//  AddVideoViewController.swift
//  CoachyFitApp
//
//  Created by Mac on 05/06/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import AVKit
import Firebase
import AVFoundation
import MobileCoreServices
import Alamofire

class AddVideoViewController: UIViewController, UINavigationControllerDelegate {

    
    @IBOutlet weak var rotateLeftOutlet: UIButton!
    @IBOutlet weak var rotateRightOutlet: UIButton!
    @IBOutlet weak var VideoName: UITextField!
    @IBOutlet weak var expertiesPicker: UIPickerView!
    @IBOutlet weak var videoPlaceHolder: UIImageView!
    
    
    var typesPicker = ["TRX","CrossFit","זומבה","גומיות","פילאטיס","יוגה","אירובי","בטן","אחר"]
    var coach = Coach(dict: ["":""])
    var rotated = CGFloat(0)
    var profileURL = ""
    var diplomaURL = ""
 
    @IBAction func rotateLeft(_ sender: UIButton) {
        rotated = rotated - .pi / 2
        videoPlaceHolder.transform = CGAffineTransform(rotationAngle: rotated)
      print(rotated)
    }
    
    @IBAction func rotateRight(_ sender: UIButton) {
        rotated = rotated + .pi / 2
        videoPlaceHolder.transform = CGAffineTransform(rotationAngle: rotated)
    }

    @IBAction func doneBtn(_ sender: UIButton) {
        
        guard let coach = self.coach else {print("coach is nil")
            return
        }
        
        coach.video[coach.video.count - 1]["rotated"]  = rotated.description
       
            let ref = Coach.ref.child(coach.id)
                          
                          ref.setValue(coach.dict)
       
        
        showSuccess(title: "הסרטון עלה בהצלחה", subtitle: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            Router.shared.chooseMainViewController()
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  

     let tapGestureRecognizerVideo = UITapGestureRecognizer(target: self, action: #selector(videoTapped(tapGestureRecognizer:)))
        videoPlaceHolder.isUserInteractionEnabled = true
        videoPlaceHolder.addGestureRecognizer(tapGestureRecognizerVideo)

    }

    
    @objc func videoTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView

        // Your action
        if self.VideoName.text != ""{
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum, type: "video")
        }else {
        
            let alert = UIAlertController(title: "לא תקין", message: "אנא הכנס שם לסרטון", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "הבנתי", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
          
            present(alert, animated: true)
            
        }
    }

}
extension AddVideoViewController: UIImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
  

  
 func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }

      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          return typesPicker.count
      }
  
      func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
  
        
          return typesPicker[row]
  
      }
  
  
      func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
              let attributedString = NSAttributedString(string: typesPicker[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
              return attributedString
  
      }
  
      func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
  
        
    }
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let mediaType = info[.mediaType] ,
                mediaType as! String   == (kUTTypeMovie as String) ,
                let url = info[.mediaURL] as? NSURL
               {
                guard let coach = self.coach else {return}

                
                let videoType = typesPicker[expertiesPicker.selectedRow(inComponent: 0)]
                
                let storageRef = Storage.storage().reference().child("coaches").child(Auth.auth().currentUser!.uid).child("videos").child(VideoName.text ?? coach.fullName + "s video")

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
                        let videoUrl = url
                        let video = ["kind": videoType, "name": strongSelf.VideoName.text!, "uri": videoUrl.absoluteString, "captured": "", "rotated": "0"] as [String : Any]
        //                    videoUrl.absoluteString!
                        coach.video.append(video)
                       
                        strongSelf.videoPlaceHolder.image?.jpegData(compressionQuality: 1)
          
                        captureImage(fileUrl: url, videoImage: (strongSelf.videoPlaceHolder)!, progressBar: nil, rotateleft: strongSelf.rotateLeftOutlet, rotateright: strongSelf.rotateRightOutlet)
                        
                        
                        
                        guard var capturedData = captureImageToFirebase(videoUrl: url) else {return}
                        print(capturedData)
                        
                       
                       
              
                        let captureID = String(decoding: capturedData, as: UTF8.self)
                        let storRef = Storage.storage().reference().child("coaches").child(Auth.auth().currentUser!.uid).child("captures").child(coach.video[coach.video.count - 1]["name"] as! String  + "_captured" )
                               
                        let captureTask = storRef.putData( capturedData , metadata: nil) { (metadata, err) in
                                   if err != nil {
                                       print(err)
                                   }
                                 let captureDownload =  storRef.downloadURL { (capurl, error) in
                                  
                                 
                                       if error != nil {
                                           print(error)
                                       }
                                    if coach.video.count > 0 {
                                        guard capurl != nil else {print("captured returned nil")
                                                                     return
                                                                 }
                                        coach.video[coach.video.count - 1 ]["captured"] = capurl!.absoluteString
                                     
                                        
                                    }
                                   }
                               }
                          }
                        }
                self.coach = coach
        }
        dismiss(animated: true){}
    }
}
