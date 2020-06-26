//
//  TestIntroViewController.swift
//  CoachyFitApp
//
//  Created by Mac on 16/05/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit

class TestIntroViewController: UIViewController {

    @IBAction func btnLogout(_ sender: UIButton) {
        googleFromLogout()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

         let facebook = FBLoginButton()
          view.addSubview(facebook)
          facebook.translatesAutoresizingMaskIntoConstraints = false
          facebook.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
          
          
          
          let google = GIDSignInButton()
          view.addSubview(google)
          google.translatesAutoresizingMaskIntoConstraints = false
          google.topAnchor.constraint(equalTo: facebook.bottomAnchor, constant: 32).isActive = true
          
          
        
          
          facebook.delegate = self
          GIDSignIn.sharedInstance()?.presentingViewController = self
          GIDSignIn.sharedInstance().signIn()
          GIDSignIn.sharedInstance().delegate = self
          
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension TestIntroViewController: LoginButtonDelegate{
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
                if error != nil {
                print("failed connecting to facebook", error)
                return
            }
            
            let accesstoken = AccessToken.current
            guard let accessTokenString = accesstoken?.tokenString else {return}
            
            let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
            // assign credentials to firebase authentication
            Auth.auth().signIn(with: credentials, completion:  {
                (user, err) in
                if err != nil{
                    print(err)
                    self.showError()
                }
                self.showSuccess()
                print("success")
                print(AccessToken.current)
                print(AccessToken.current?.userID)
                print(Auth.auth().currentUser?.uid)
//                Router.shared.chooseMainViewController()
            
            })
        
//        GraphRequest(graphPath: "/me", parameters: ["fields":"id, name, email"]).start { (connection, result, err) in
//            if err != nil{
//                print(err)
//            }
//        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("logout")
        do{
            try Auth.auth().signOut()
        }catch let err{
            print(err)
        }
        
    }
        
    
}

extension TestIntroViewController:GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil{
            self.showError()
               print("failed connecting to google", error)
               return
           }
           
                guard let authentication = user.authentication else { return }
                let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,                                               accessToken: authentication.accessToken)
           // assigns credentials to fireBase authentication
        Auth.auth().signIn(with: credential) { (authResult, error) in
             if error != nil  {
                self.showError()
               print("failed authenticating", error)
           }
            self.showSuccess()
            print(GIDSignIn.sharedInstance()?.currentUser)
            print(Auth.auth().currentUser)
           print("logged in succeeded")
//            Router.shared.chooseMainViewController()
           
        }
         
    }
    
    func googleFromLogout(){
        do{
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance()?.signOut()
            print(GIDSignIn.sharedInstance()?.currentUser)
        }catch let err{
            print("err",err)
        }
    }
    
    
}
