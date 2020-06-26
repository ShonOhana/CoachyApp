//
//  VideoHelper.swift
//  CoachyFitApp
//
//  Created by Mac on 14/05/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import Alamofire
import PKHUD



class VideoHelper {
  
    static func startMediaBrowser(delegate: UIViewController & UINavigationControllerDelegate & UIImagePickerControllerDelegate, sourceType: UIImagePickerController.SourceType, type: String ) {
    guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
    
        if type == "video"{
            let mediaUI = UIImagePickerController()
               mediaUI.sourceType = sourceType
               mediaUI.mediaTypes = [kUTTypeMovie as String]
               mediaUI.allowsEditing = true
               mediaUI.delegate = delegate
               delegate.present(mediaUI, animated: true, completion: nil)
        }
        else if type == "image"{
            let mediaUI = UIImagePickerController()
                          mediaUI.sourceType = sourceType
                          mediaUI.mediaTypes = [kUTTypeImage as String]
                          mediaUI.allowsEditing = true
                          mediaUI.delegate = delegate
                          delegate.present(mediaUI, animated: true, completion: nil)
        }
   
  }

  
}


func captureImage(fileUrl: URL, videoImage: UIImageView, progressBar: UIProgressView?, rotateleft: UIButton, rotateright: UIButton){
    DispatchQueue.main.async {
        let asset = AVAsset(url: fileUrl )
        let ImageGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let CGImage = try ImageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            
           
                        DispatchQueue.main.async {
                            AF.request(fileUrl).downloadProgress(closure: { (progress)in
                                progressBar?.progress = Float(progress.fractionCompleted)
                                }).response { (response) in
                                        DispatchQueue.main.async {
                                            videoImage.image = UIImage(cgImage: CGImage)
                                    }
                                    progressBar?.isHidden = true
                                    HUD.flash(.success, delay: 1)
                            }
                        }
            
            
        }catch let e{
            HUD.flash(.labeledError(title: "משהו השתבש", subtitle: "אנא נסה שנית"),delay: 1)
            print("error getting capture", e)
        }
    }

    
}
func captureImageToFirebase(videoUrl: URL) -> Data? {
//    DispatchQueue.global(qos: .background).async {
          let asset = AVAsset(url: videoUrl )
          let ImageGenerator = AVAssetImageGenerator(asset: asset)
          do {
              let CGImage = try ImageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
              
              DispatchQueue.global(qos: .userInteractive).async {
                          DispatchQueue.main.async {
//                          videoImage.image = UIImage(cgImage: CGImage)
                  }
              }
           let ui = UIImage(cgImage: CGImage)
            
            let pngImage = ui.pngData()
            return pngImage
          }catch let e{
              print("error getting capture", e)
          }
//      }

    return nil
}
