//
//  RegisterViewController.swift
//  CoachyFitApp
//
//  Created by Mac on 21/05/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import PKHUD
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var rePasswordTextField: UITextField!
    
    
    @IBOutlet weak var registerOutlet: UIButtonX!
    @IBAction func register(_ sender: UIButton) {
        
        
        
        guard isEmailValid && isPasswordValid && isRePasswordValid, let email = emailTextField.text,
        let password = passwordTextField.text else {
            return
        }
        
        //may be empty
        var nickName = nameTextField.text!
        
        //if the nickName is empty (split the email)
        nickName = !nickName.isEmpty ? nickName : String(email.split(separator: "@")[0])
        
        showProgress(title: "please wait")
        //dont allow the user click twice
        sender.isEnabled = false
        
        //firebase
        Auth.auth().createUser(withEmail: email, password: password) {[weak self] (result, error) in
            guard let result = result else{
                let errorMessage = error?.localizedDescription ?? "Unknown error"
                sender.isEnabled = true
                self?.showError(title: errorMessage)
                return
            }
            
            //success
            //we didnt use the nickname
            let user = result.user
            
            //update nickname
            let profileChangeRequest = user.createProfileChangeRequest()
            profileChangeRequest.displayName = nickName
            
            //apply the nickname
            profileChangeRequest.commitChanges { (error) in
                if let error = error {
                    let text = error.localizedDescription
                    self?.showError(title: "Registered failed", subtitle: text)
                }else{
                    self?.showSuccess()
                    Router.shared.chooseMainViewController()
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerOutlet.contentEdgeInsets = UIEdgeInsets(top: 5,left: 10,bottom: 5,right: 10) 

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

protocol UserValidation:ShowHUD {
    //check the email valid
    var emailTextField:UITextField!{get}
    var passwordTextField: UITextField!{get}
    var rePasswordTextField: UITextField!{get}
}

extension UserValidation{
    var isEmailValid:Bool{
        
        guard let email = emailTextField.text, !email.isEmpty else {
            showLabel(title: "Email not valid")
            return false
        }
        
        //email valid
        return true
    }
    
    var isPasswordValid:Bool{
        
        guard let password = passwordTextField.text, password.count > 6  else {
            showLabel(title: "Password too short")
            return false
        }
        
        return true
    }
    
    var isRePasswordValid:Bool{
        
        guard let rePassword = rePasswordTextField.text, rePassword == passwordTextField.text else {
            showLabel(title: "Password dont match")
            return false
        }
        
        //email valid
        return true
    }
}

extension RegisterViewController:UserValidation{}
extension IntroViewController:UserValidation{
    var rePasswordTextField: UITextField! {
        .none
    }
}
