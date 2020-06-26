//
//  IntroViewController.swift
//  CoachyFitApp
//
//  Created by Mac on 14/05/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import PKHUD
import AVKit

class IntroViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var coachyLabel: UIView!
    @IBOutlet weak var seperateLine: UIView!
    @IBOutlet weak var welcomeCoachyLabel: UILabel!
    @IBOutlet weak var otherRegisterLabel: UILabel!
    @IBOutlet weak var btnsStack: UIStackView!
    @IBOutlet weak var muteButtonPicture: UIButton!
    @IBOutlet weak var coachyLogo: UIImageView!
    @IBOutlet weak var videoLayer: UIView!
    @IBOutlet var coachDialog: UIView!
    @IBOutlet weak var blur: UIVisualEffectView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var coachGoogle: GIDSignInButton!
    
    //boolean params:
    var isDialogShow = false
    var isCoach = false
    var isRegitererd = false
    var didLogOut = false
    // make sure facebook button wont add more than once
    var facebookadd = false
    var mute = true
    
    //properties
    // randomise intros
    var counter = Int.random(in: 1..<4)
    // players
    var player =  AVPlayer()
    var AudioPlayer = AVAudioPlayer()
    
    //actions
    @IBAction func openRegisterBtn(_ sender: UIButton) {
        coachDialog.frame.size.height = 350
        btnsStack.isHidden = false
        emailTextField.isHidden = false
        passwordTextField.isHidden = false
        otherRegisterLabel.isHidden = true
        sender.isHidden = true
        emailTextField.topAnchor.constraint(equalTo: seperateLine.bottomAnchor, constant: 8).isActive = true
        coachDialog.bottomAnchor.constraint(equalTo: btnsStack.bottomAnchor, constant: 8).isActive = true
    }
    
    
    @IBAction func login(_ sender: UIButton) {
                guard isEmailValid && isPasswordValid, let email = emailTextField.text,
                         let password = passwordTextField.text else {
                             return
                         }

                         //dont allow the user click twice
                         sender.isEnabled = false

                         //firebase
                         Auth.auth().signIn(withEmail: email, password: password) {[weak self] (result, error) in
                             guard let _ = result else{
                                 let errorMessage = error?.localizedDescription ?? "Unknown error"
                                 sender.isEnabled = true
                                 
                                let alert = UIAlertController(title: "שגיאה", message: errorMessage, preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "הבנתי", style: .default, handler: {[weak self] (action) in
                                    alert.dismiss(animated: true)
                                    
                                }))
                                
                                self?.present(alert, animated: true)
                                
                                 return
                             }

                           Router.shared.chooseMainViewController()

                         }
    }
    
    func addBackgroundMusic(name: String){
        let AssortedMusics = NSURL(fileURLWithPath: Bundle.main.path(forResource: name, ofType: "mp3")!)
        AudioPlayer = try! AVAudioPlayer(contentsOf: AssortedMusics as URL)
        AudioPlayer.prepareToPlay()
        AudioPlayer.numberOfLoops = -1
        AudioPlayer.play()
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    
    func playVideo() {
            switch counter {

            case 1:
                    player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "intro1", ofType: "mov")!))
                    player.actionAtItemEnd = .none
                    NotificationCenter.default.addObserver(self,
                                                        selector: #selector(playerItemDidReachEnd(notification:)),
                                                        name: .AVPlayerItemDidPlayToEndTime,
                                                        object: player.currentItem)
                counter = counter + 1

            case 2:
                player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "intro2", ofType: "mov")!))
                player.actionAtItemEnd = .none
                NotificationCenter.default.addObserver(self,
                                                        selector: #selector(playerItemDidReachEnd(notification:)),
                                                        name: .AVPlayerItemDidPlayToEndTime,
                                                        object: player.currentItem)
                counter = counter + 1

            case 3:
                player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "intro3", ofType: "mov")!))
                player.actionAtItemEnd = .none
                NotificationCenter.default.addObserver(self,
                                                        selector: #selector(playerItemDidReachEnd(notification:)),
                                                        name: .AVPlayerItemDidPlayToEndTime,
                                                        object: player.currentItem)
                counter = 1

            default:
                print("error")
            }

            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.view.bounds
            playerLayer.videoGravity = .resizeAspectFill
            self.videoLayer.layer.addSublayer(playerLayer)
            

            player.play()



        }

    @IBAction func muteButton(_ sender: UIButton) {
    
                if mute {
                    mute = false
                    AudioPlayer.pause()
                    muteButtonPicture.setImage(UIImage.init(named: "icons8-mute"), for: .normal)
                } else {
                    mute = true
                    AudioPlayer.play()
                    muteButtonPicture.setImage(UIImage.init(named: "icons8-sound"), for: .normal)
                }
    
        }

    func addFBButton(dialog: UIView, google:GIDSignInButton){
        self.facebookadd = true
        let facebook = FBLoginButton()
        facebook.delegate = self
    
        dialog.addSubview(facebook)
      
        facebook.translatesAutoresizingMaskIntoConstraints = false
        facebook.frame.size.height = 40
        facebook.topAnchor.constraint(equalTo: google.bottomAnchor, constant: 8).isActive = true
        facebook.leftAnchor.constraint(equalTo: coachDialog.leftAnchor, constant: 8).isActive = true
        facebook.centerXAnchor.constraint(equalTo: dialog.centerXAnchor).isActive = true
        self.facebookadd = false
    }
    

    func dismissDialog(){
            UIView.animate(withDuration: 0.8, animations: {
                self.coachDialog.center = CGPoint(x: self.view.center.x, y: -55)
            }) { (isComplete) in
                self.coachDialog.removeFromSuperview()
            }

        }
    
        // add a animation for dialog
    func addDialog(dialog: UIView){

            let landing = CGPoint(x: self.view.center.x, y: self.view.center.y - 120)
                self.view.addSubview(dialog)
                 dialog.center = CGPoint(x: self.view.center.x, y: 0)

                 UIView.animate(withDuration: 2, animations: {
                    
                    dialog.center = landing

                        }) { (isComplete) in

                            dialog.center = landing

                }
            
        }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        //hide the unrelevant register kind (hide not google or facebook)
        coachDialog.frame.size.height = 200
        btnsStack.isHidden = true
        emailTextField.isHidden = true
        passwordTextField.isHidden = true
        coachDialog.bottomAnchor.constraint(equalTo: otherRegisterLabel.bottomAnchor, constant: 8).isActive = true
        welcomeCoachyLabel.bottomAnchor.constraint(equalTo: coachGoogle.topAnchor, constant: 8).isActive = true
        coachDialog.topAnchor.constraint(equalTo: welcomeCoachyLabel.topAnchor, constant: 8).isActive = true
        

        playVideo()
        addBackgroundMusic(name: "arad-bit")
        
        //add the view so we can see them over the video
        view.addSubview(muteButtonPicture)
        view.addSubview(coachyLogo)
        view.addSubview(coachyLabel)
        
        addDialog(dialog: coachDialog)
        addFBButton(dialog: coachDialog, google: coachGoogle)
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self

        
}
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        AppUtility.lockOrientation(.portrait)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        AppUtility.lockOrientation(.all)
    }

}

extension IntroViewController: LoginButtonDelegate{
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
                if error != nil {
                return
            }
            
            let accesstoken = AccessToken.current
            guard let accessTokenString = accesstoken?.tokenString else {return}
            
            let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
            // assign credentials to firebase authentication
            Auth.auth().signIn(with: credentials, completion:  {[weak self]
                (user, err) in
                if err != nil{
                    print(err)
                    self?.showError()
                }
                
                self?.showProgress(title: "Please wait", subtitle: nil)
                let user = User(isCoach: false, needsMoreDetails: true, id: (Auth.auth().currentUser?.uid)!, name: "", isLoggedIn: true)
                
                saveUserToDefaults(user)
                Router.shared.chooseMainViewController()
            
            })
        

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

extension IntroViewController:GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil{

               return
           }
           
                guard let authentication = user.authentication else { return }
                let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,                                               accessToken: authentication.accessToken)
           // assigns credentials to fireBase authentication
        Auth.auth().signIn(with: credential) {[weak self] (authResult, error) in
             if error != nil  {
               print("failed authenticating", error)
           }
            
            
                
            let user = User(isCoach: false, needsMoreDetails: true, id: (Auth.auth().currentUser?.uid)!, name: GIDSignIn.sharedInstance()?.currentUser.profile.name ?? "", isLoggedIn: true)
            
            saveUserToDefaults(user)

            Router.shared.chooseMainViewController()
            
        }
         
    }
    
    func googleLogout(){
        do{
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance()?.signOut()
        }catch let err{
            print("err",err)
        }
    }
    
    
}
