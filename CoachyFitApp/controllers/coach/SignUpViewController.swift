//
//  SignUpViewController.swift
//  CoachyFitApp
//
//  Created by Mac on 16/05/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import MobileCoreServices
import FBSDKLoginKit
import GoogleSignIn
import AVKit



class SignUpViewController: UIViewController {

    //btns seniority
    var trxText = ""
    var crossfitText = ""
    var rubberTrainText = ""
    var bodyWeightText = ""
    var yogaText = ""
    var pilatisText = ""
    var zumbaText = ""
    var aerobicText = ""
    var absText = ""
    var otherText = ""
    var specilized = [String]()
    

    

    @IBOutlet weak var detailsStack: UIStackView!
    @IBOutlet weak var must6: UILabel!
    @IBOutlet weak var must5: UILabel!
    @IBOutlet weak var must4: UILabel!
    @IBOutlet weak var must3: UILabel!
    @IBOutlet weak var must2: UILabel!
    @IBOutlet weak var must1: UILabel!
    @IBOutlet weak var doneButton: UIButtonX!
    @IBOutlet weak var pageTitle: UILabelX!
    @IBOutlet weak var matchDiplomaDateLabel: UILabel!
    @IBOutlet weak var coachName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var TRXBtnOutlet: UIButton!
    @IBOutlet weak var rubberBandOutlet: UIButton!
    @IBOutlet weak var bodyWeight: UIButton!
    @IBOutlet weak var CrossfitBtnOutlet: UIButton!
    @IBOutlet weak var aerobicOutlet: UIButton!
    @IBOutlet weak var yogaOutlet: UIButton!
    @IBOutlet weak var pilatisOutlet: UIButton!
    @IBOutlet weak var absOutlet: UIButton!
    @IBOutlet weak var otherOutlet: UIButton!
    @IBOutlet weak var seniorityTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    func addToSeniority(_ sender: UIButton, text: String, outlet: UIButton) -> String{
        var text = text
        sender.alpha = sender.alpha == 1 ? 0.5 : 1
        if sender.alpha == 0.5{
            text = outlet.titleLabel?.text as! String
        } else {
            text = ""
        }
        return text
    }
    
    @IBAction func TRX(_ sender: UIButton) {
        trxText = addToSeniority(sender, text: trxText, outlet: TRXBtnOutlet)
    }
    @IBAction func CrossFit(_ sender: UIButton) {
        crossfitText = addToSeniority(sender, text: crossfitText, outlet: CrossfitBtnOutlet)
    }
    @IBAction func BodyWeight(_ sender: UIButton) {
        bodyWeightText = addToSeniority(sender, text: bodyWeightText, outlet: bodyWeight)
    }
    
    @IBAction func RubberTrain(_ sender: UIButton) {
        rubberTrainText = addToSeniority(sender, text: rubberTrainText, outlet: rubberBandOutlet)
    }
    
    @IBAction func aerobic(_ sender: UIButton) {
       aerobicText = addToSeniority(sender, text: aerobicText, outlet: aerobicOutlet)
    }
    
    @IBAction func yoga(_ sender: UIButton) {
       yogaText = addToSeniority(sender, text: yogaText, outlet: yogaOutlet)
    }
    @IBAction func pilatis(_ sender: UIButton) {
       pilatisText = addToSeniority(sender, text: pilatisText, outlet: pilatisOutlet)
    }
    
    @IBAction func abs(_ sender: UIButton) {
       absText = addToSeniority(sender, text: absText, outlet: absOutlet)
    }
    
    
    @IBAction func other(_ sender: UIButton) {
       otherText = addToSeniority(sender, text: otherText, outlet: otherOutlet)
    }
    

    
    @IBAction func doneBtn(_ sender: UIButton) {
        
        guard isNameValid && isPhoneValid && isAgeValid
            && isDescriptionValid && isSeniorityValid && isSpecializedValid else{return}
        
//        guard let vc = self.storyboard?.instantiateViewController(identifier: "SignUp2ViewController") as? SignUp2ViewController else {return}
//        vc.coach.fullName = coachName.text ?? ""
//        vc.coach.phone = phoneNumber.text ?? ""
//        vc.coach.seniority = seniorityTextField.text ?? ""
//        vc.coach.age = ageTextField.text ?? ""

        
        
            let specialize = [trxText,crossfitText,rubberTrainText,bodyWeightText,zumbaText,absText,pilatisText,yogaText,otherText,aerobicText]

        
            for i in specialize{
                if i != ""{
                    specilized.append(i)
                }
            }
//        vc.coach.specialize = specilized
//        vc.coach.description = descriptionTextView.text ?? ""
//        vc.coach.id = coach.id
        
        
        let ref = Coach.ref.child(Auth.auth().currentUser!.uid)
             ref.observeSingleEvent(of: .value) {[weak self] (snapshot) in
                    Coach.ref.child((self?.coach.id)!).child("name").setValue(self?.coachName.text)
                    Coach.ref.child((self?.coach.id)!).child("phone").setValue(self?.phoneNumber.text)
                    Coach.ref.child((self?.coach.id)!).child("age").setValue(self?.ageTextField.text)
                    Coach.ref.child((self?.coach.id)!).child("seniority").setValue(self?.seniorityTextField.text)
                    Coach.ref.child((self?.coach.id)!).child("description").setValue(self?.descriptionTextView.text)
                    Coach.ref.child((self?.coach.id)!).child("specialize").setValue(self?.specilized)
                    Coach.ref.child((self?.coach.id)!).child("diploma").setValue("")
                    Coach.ref.child((self?.coach.id)!).child("profileImage").setValue("")
                    self?.showSuccess(title: "הפרטים נקלטו בהצלחה", subtitle: nil)
                
                self?.specilized.removeAll()
                
                let sb = UIStoryboard(name: "CoachInfo", bundle: .main)
                let vc = sb.instantiateViewController(withIdentifier: "CoachTabBar") as! UITabBarController
                vc.tabBar.items![0].isEnabled = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    Router.shared.chooseMainViewController()
                }
                
                
                
        }
        
                    
        
    }
    
    var coach = Coach(id: "", fullName: "", age: "", description: "", seniority: "", phone: "", gender: "", profileImage: "", diploma: "", video: [], specialize: [])
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        let bottomLine1 = CALayer()
        bottomLine1.frame = CGRect(x: 0, y: coachName.frame.height - 2, width: coachName.frame.width, height: 1)
        bottomLine1.backgroundColor = UIColor.black.cgColor
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 0, y: coachName.frame.height - 2, width: coachName.frame.width, height: 1)
        bottomLine2.backgroundColor = UIColor.black.cgColor
        let bottomLine3 = CALayer()
        bottomLine3.frame = CGRect(x: 0, y: coachName.frame.height - 2, width: coachName.frame.width, height: 1)
        bottomLine3.backgroundColor = UIColor.black.cgColor
        let bottomLine4 = CALayer()
        bottomLine4.frame = CGRect(x: 0, y: coachName.frame.height - 2, width: coachName.frame.width, height: 1)
        bottomLine4.backgroundColor = UIColor.black.cgColor
        
        coachName.layer.addSublayer(bottomLine1)
        phoneNumber.layer.addSublayer(bottomLine2)
        ageTextField.layer.addSublayer(bottomLine3)
        seniorityTextField.layer.addSublayer(bottomLine4)
        
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.text = "קצת על עצמך"
        descriptionTextView.textColor = UIColor.lightGray
        if descriptionTextView.text != nil{
            
            textViewDidBeginEditing(descriptionTextView)
        }
        
        
        

        let agePicker = UIDatePicker()
        let seniorityPicker = UIDatePicker()
        
        
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.viewTapped(tapGestureRecognizer:)))
        
        view.addGestureRecognizer(tapScreen)
        ageTextField.inputView = ageDatePicker(datePicker: agePicker)
        seniorityTextField.inputView = seniorityDatePicker(datePicker: seniorityPicker)
        

        
        if GIDSignIn.sharedInstance()?.currentUser != nil {
            let name = GIDSignIn.sharedInstance()?.currentUser.profile.name
            
            coachName.text  = name
        }else if AccessToken.current != nil{
            let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"id, email, name"])
            graphRequest.start { (connection, result, err) in
                if err != nil{
                    print(err)
                }
                 let data:[String:AnyObject] = result as! [String : AnyObject]
                self.coachName.text = data["name"] as? String
            }
        }
        readFromDB()
    }
    
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        AppUtility.lockOrientation(.portrait)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        AppUtility.lockOrientation(.all)
    }
    
    
    func ageDatePicker(datePicker: UIDatePicker) -> UIDatePicker{
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(ageDateChanged(datePicker:)), for: .valueChanged)
        return datePicker
    }
    
        @objc func ageDateChanged(datePicker:UIDatePicker){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            ageTextField.text = dateFormatter.string(from: datePicker.date)
        }
    
    func seniorityDatePicker(datePicker: UIDatePicker) -> UIDatePicker{
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(seniorityDateChanged(datePicker:)), for: .valueChanged)
        return datePicker
    }
    
        @objc func seniorityDateChanged(datePicker:UIDatePicker){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            seniorityTextField.text = dateFormatter.string(from: datePicker.date)
        }
    
    @objc func viewTapped(tapGestureRecognizer:UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func readFromDB(){
        guard let id = Auth.auth().currentUser?.uid else {return}
            
               coach.id = id

                   let ref  = Database.database().reference().child("coaches").child(id)
                   ref.observeSingleEvent(of: .value) {[weak self] (snapshot) in
                       if snapshot.exists(){
                        self?.coachName.isEnabled = false
                        self?.coachName.alpha = 0.7
                        self?.ageTextField.isEnabled = false
                        self?.ageTextField.alpha = 0.7
                        self?.seniorityTextField.isEnabled = false
                        self?.seniorityTextField.alpha = 0.7
                        self?.doneButton.setTitle("עדכן", for: .normal)
                        self?.must1.isHidden = true
                        self?.must2.isHidden = true
                        self?.must3.isHidden = true
                        self?.must4.isHidden = true
                        self?.must5.isHidden = true
                        self?.must6.isHidden = true
                        self?.matchDiplomaDateLabel.isHidden = true
                        self?.detailsStack.spacing = 36
                        self?.pageTitle.text = "עדכון נתונים"
                           let read = snapshot.value as? [String : Any] ?? [:]
                           self?.coach.fullName = (read["name"] as! String)
                           self?.coach.age = (read["age"] as! String)
                           self?.coach.description = (read["description"] as! String)
                           self?.coach.phone = (read["phone"] as! String)
                           self?.coach.seniority = (read["seniority"] as! String)
                        self?.coach.specialize = (read["specialize"] ) as? [String] ?? []
                           
                           self?.coachName.text = self?.coach.fullName
                           self?.ageTextField.text = self?.coach.age
                           self?.descriptionTextView.text = self?.coach.description
                           self?.seniorityTextField.text = self?.coach.seniority
                           self?.phoneNumber.text = self?.coach.phone
                        self?.specilized = self?.coach.specialize as! [String]
                    
                           
                        for spec in (self?.specilized)!{
                           
                               switch spec {
                               case "TRX":
                                   self?.TRXBtnOutlet.alpha = 0.5
                               case "Crossfit":
                                   self?.CrossfitBtnOutlet.alpha = 0.5
                               case "פונקציונלי":
                                   self?.bodyWeight.alpha = 0.5
                               case "בטן":
                                   self?.absOutlet.alpha = 0.5
                               case "אירובי":
                                   self?.aerobicOutlet.alpha = 0.5
                               case "יוגה":
                                   self?.yogaOutlet.alpha = 0.5
                               case "פילאטיס":
                                   self?.pilatisOutlet.alpha = 0.5
                               case "גומיות":
                                   self?.rubberBandOutlet.alpha = 0.5
                               case "אחר":
                                   self?.otherOutlet.alpha = 0.5
                               default: break
                               }
                                  
                   }
               }
            }
    }

}

protocol CheckAll:ShowHUD {
    var coachName:UITextField!{get}
    var phoneNumber: UITextField!{get}
    var ageTextField:UITextField!{get}
    var seniorityTextField: UITextField!{get}
    var descriptionTextView:UITextView!{get}
    var TRXBtnOutlet: UIButton!{get}
    var rubberBandOutlet: UIButton!{get}
    var bodyWeight: UIButton!{get}
    var CrossfitBtnOutlet: UIButton!{get}
    var aerobicOutlet: UIButton!{get}
    var yogaOutlet: UIButton!{get}
    var pilatisOutlet: UIButton!{get}
    var absOutlet: UIButton!{get}
    var otherOutlet: UIButton!{get}
    
}

extension CheckAll{
    
    var isSpecializedValid:Bool{
        
        guard TRXBtnOutlet.alpha == 0.5 ||
        rubberBandOutlet.alpha == 0.5 ||
        bodyWeight.alpha == 0.5 ||
        CrossfitBtnOutlet.alpha == 0.5 ||
        aerobicOutlet.alpha == 0.5 ||
        yogaOutlet.alpha == 0.5 ||
        pilatisOutlet.alpha == 0.5 ||
        absOutlet.alpha == 0.5 ||
        otherOutlet.alpha == 0.5
        else{
            showLabel(title: "חייב לבחור לפחות התמחות אחת")
            return false
        }
        return true
    }
    
    var isNameValid:Bool{

        guard let name = coachName.text, !name.isEmpty else {
            showLabel(title: "אנא מלא את שמך המלא")
            return false
        }

        return true
    }

    //make better vakidation
    var isPhoneValid:Bool{

        guard let phone = phoneNumber.text, phone.count == 10 else {
            showLabel(title: "מספר פלאפון לא תקין ")
            return false
        }

        return true
    }

    var isAgeValid:Bool{

        guard let age = ageTextField.text, !age.isEmpty else {
            showLabel(title: "אנא הזן את גילך")
            return false
        }

        return true
    }

    var isSeniorityValid:Bool{

        guard let seniority = seniorityTextField.text, !seniority.isEmpty else {
            showLabel(title: "אנא הזן את הותק שלך בתור מאמן")
            return false
        }

        return true
    }
    var isDescriptionValid:Bool{

        guard let description = descriptionTextView.text, description.count < 70 && description.count > 1 else {
            showLabel(title: "כתוב בקצרה על עצמך עד 70 תווים")
            return false
        }
        return true
    }
    


}

extension SignUpViewController: CheckAll{}

