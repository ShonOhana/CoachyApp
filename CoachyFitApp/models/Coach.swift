//
//  Coach.swift
//  CoachyFitApp
//
//  Created by Mac on 13/05/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage


class Coach:FirebaseModel{

    //properties
    var id: String
    var fullName:String
    var age: String
    var description: String
    var seniority: String
    var phone: String
    var profileImage: String? // to uri
    var diploma: String? // to uri
    var video: [Dictionary<String,Any>]
    var specialize: [String]
 
    

    //from json to object
    var dict: [String : Any]{
    

        
        var videosArr = [Dictionary<String,Any>]()
        
        let singleVideo = Video(dict: ["name" : "",
                                       "uri":  "",
                                       "kind": "" ,
                                       "captured": "",
                                       "rotated":"0", "purchases":[""]])
            
        for v in video{
            let name = v["name"] as? String
            let uri = v["uri"] as? String
            let kind = v["kind"] as? String
            let captured = v["captured"] as? String
            let rotated = v["rotated"] as? String
            let purchases = v["purchases"] as? [String]
            guard let thisVideo = singleVideo else {return [:]}
            thisVideo.name = name ?? ""
            thisVideo.uri = uri ?? ""
            thisVideo.kind = kind ?? ""
            thisVideo.captured = captured ?? ""
            thisVideo.rotated = rotated ?? "0"
            thisVideo.purchases = purchases ?? [""]
            
            videosArr.append(thisVideo.dict)
        }
        
        let dict = [CoachKeys.id.rawValue : id,
                    CoachKeys.name.rawValue: fullName,
                    CoachKeys.age.rawValue: age,
                    CoachKeys.description.rawValue: description,
                    CoachKeys.seniority.rawValue : seniority,
                    CoachKeys.phone.rawValue : phone,
                    CoachKeys.profileImage.rawValue: profileImage,
                    CoachKeys.diploma.rawValue: diploma,
                    CoachKeys.video.rawValue: videosArr,
                    CoachKeys.specialize.rawValue: specialize] as [String:Any]

        return dict
    }

    
    init(id: String, fullName:String, age:String, description: String, seniority: String, phone:String, gender:String, profileImage: String, diploma: String, video:[Dictionary<String, Any>], specialize: [String] ) {
        self.id = id
        self.fullName = fullName
        self.age = age
        self.description = description
        self.seniority = seniority
        self.phone = phone
        self.profileImage = profileImage
        self.diploma = diploma
        self.video = video
        self.specialize = specialize
    }


    required init?(dict: [String : Any]) {
        
        guard let id = dict["id"] as? String,
        let fullName = dict["name"] as? String,
        let age = dict["age"] as? String,
        let description = dict["description"] as? String,
        let seniority = dict[CoachKeys.seniority.rawValue] as? String,
        let phone = dict[CoachKeys.phone.rawValue] as? String,
        let profileImage = dict[CoachKeys.profileImage.rawValue] as? String,
        let diploma = dict[CoachKeys.diploma.rawValue] as? String,
        let videoDict = dict["video"] as? [Dictionary<String,Any>],
        let specialize = dict[CoachKeys.specialize.rawValue] as? [String]

    else{return nil}

        self.id = id
        self.fullName = fullName
        self.age = age
        self.description = description
        self.seniority = seniority
        self.phone = phone
        self.profileImage = profileImage
        self.diploma = diploma
        self.video = videoDict
        self.specialize = specialize
            
        }
        
    enum CoachKeys: String{
        case id = "id"
        case name = "name"
        case age = "age"
        case description = "description"
        case seniority = "seniority"
        case diploma = "diploma"
        case phone = "phone"
        case profileImage = "profileImage"
        case video = "video"
        case specialize = "specialize"
        case uri = "uri"
        case kind = "kind"
    }
        
    }

    

extension Coach{
    static var ref: DatabaseReference{
        return Database.database().reference().child("coaches")
    }
    
    //storage of images
    var imageRef:StorageReference{ //images are saved under RoomId
        return Storage.storage().reference().child("coaches").child("profileImages").child(id + ".jpg")
    }
    var diplomaRef:StorageReference{ //images are saved under RoomId
        return Storage.storage().reference().child("coaches").child("diploma").child(id + ".jpg")
    }
    
    //save data to database:
    func saveImageDB(callback:@escaping (Error?, Bool)->Void){
        Coach.ref.child(id).setValue(dict) {(error, dbRef) in
            if let error = error{
                callback(error, false)
                return
            }
            callback(nil, true)
        }
    }
    //save coach image:
    func saveImageStorage(profileImage: UIImage?, diploma: UIImage?, callaback: @escaping(Error?, Bool)->Void){
        //convet image to  jpeg data:
        guard let profileData = profileImage?.jpegData(compressionQuality: 1), let diplomaData = diploma?.jpegData(compressionQuality: 1) else{
            callaback(nil, false)
            return
        }
            //upload
            imageRef.putData(profileData, metadata: nil) {[weak self] (metadata, error) in
                if let error = error{
                    callaback(error, false)
                    return
            }
                self!.diplomaRef.putData(diplomaData, metadata: nil) {[weak self] (metadata, error) in
                if let error = error{
                    callaback(error, false)
                    return
            }
            
            //save image and room to database
            self?.profileImage = self!.id + "profileImage" + ".jpg"
            self?.diploma = self!.id + "diploma" + ".jpg"
            self?.saveImageDB(callback: callaback)

                }
    
        }

    }
    // return array with First videos only
       func getFirstVideos(coach: Coach) ->[[String: Any]] {
           var firstVideos = [[String: Any]]()

               var isTRX = false
                  var isCrossfit = false
                  var isZumba = false
                  var isRubber = false
                  var isPilates = false
                  var isYoga = false
                  var isErobi = false
                  var isStomach = false
            for i in 0..<coach.video.count{
              let type =  coach.video[i]["kind"] as! String
              //        var expertiesPicker = ["TRX","CrossFit","זומבה","גומיות","פילאטיס","יוגה","אירובי","בטן","אחר"]
                      print(type)
                      switch type {
                      case "TRX":
                          if !isTRX {
                              firstVideos.append(coach.video[i] )
                              isTRX = true
                          }
                               case "CrossFit":
                                                 if !isCrossfit {
                                                  firstVideos.append(coach.video[i] )
                                                     isCrossfit = true
                                                 }
                              case "בטן":
                                                 if !isStomach {
                                                  firstVideos.append(coach.video[i] )
                                                     isStomach = true
                                                 }
                               case "אירובי":
                                                 if !isErobi {
                                                  firstVideos.append(coach.video[i] )
                                                     isErobi = true
                                                 }
                              case "יוגה":
                                                 if !isYoga {
                                                  firstVideos.append(coach.video[i] )
                                                     isYoga = true
                                                 }
                               case "פילאטיס":
                                                 if !isPilates {
                                                  firstVideos.append(coach.video[i] )
                                                     isPilates = true
                                                 }
                               case "זומבה":
                                                 if !isZumba {
                                                  firstVideos.append(coach.video[i] )
                                                     isZumba = true
                                                 }
                               case "גומיות":
                                                 if !isRubber {
                                                  firstVideos.append(coach.video[i] )
                                                     isRubber = true
                                                 }
                          
                          
                      default:
                          firstVideos.append(coach.video[i] )
                      }
              
             
                       }
        print(firstVideos)
           return firstVideos
        }
    
    func fillAllVideosFirst() -> [[String: Any]]{
    
        var firstVideos = self.getFirstVideos(coach: self)
    for i in 0..<video.count{
        let purchases = video[i]["purchases"] as! [String]
        if purchases.contains(Auth.auth().currentUser!.uid){
            firstVideos.append( video[i])
        }
    }
    
        var allVids = [[String: Any]]()
    allVids.append( contentsOf: firstVideos)
        for i in 0..<self.video.count{
            var contains = false
            for j in 0..<firstVideos.count{

                if self.video[i]["uri"] as! String == allVids[j]["uri"] as! String{
                    contains = true
                }
            }
            if !contains{
                allVids.append( self.video[i])
            }
        }
    
        return allVids
    
    }
    
    func getFirstVideoOfKind(Kind: String) -> [String:Any]{
        var dictionary = [:] as! [String:Any]
        for i in 0..<self.video.count{
            if video[i]["kind"] as! String == Kind{
                dictionary = video[i]
            }
        }
        return dictionary
    }
    
}

func getAgeFromDOF(date: String) -> Int {

    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "MM/dd/yyyy"
    guard let dateOfBirth = dateFormater.date(from: date) else{return 0}

    let calender = Calendar.current

    let dateComponent = calender.dateComponents([.year,.month], from:
    dateOfBirth, to: Date())

    return (dateComponent.year!)
}

func getSeniorityYear(date: String) -> Int {

    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "MM/dd/yyyy"
    guard let dateOfBirth = dateFormater.date(from: date) else{return 0}

    let calender = Calendar.current

    let dateComponent = calender.dateComponents([.year], from:
    dateOfBirth)

    return (dateComponent.year!)
    

    
}
