//
//  TrainingTypesTableViewController.swift
//  CoachyFitApp
//
//  Created by Mac on 14/05/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import PKHUD
import FBSDKLoginKit
import GoogleSignIn
import FirebaseAuth
import AVKit

class TrainingTypesTableViewController: UITableViewController {
    
    @IBOutlet weak var coachBtnOutlet: UIBarButtonItem!
    
    @IBOutlet var loadingView: UIView!
    var clickedPath: IndexPath? = nil
    @IBOutlet weak var searchBar: UISearchBar!
    
    var coach = Coach(dict: [:])
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        do{
             GIDSignIn.sharedInstance()?.signOut()
             let loginManager = LoginManager()
             loginManager.logOut()
            try Auth.auth().signOut()
             Router.shared.chooseMainViewController()
         }catch let err{
             showError()
             print(err)
         }
    }
    
    
    
    func showLoadingScreen(){
        
        
        
        player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "loading2", ofType: "mp4")!))
        player.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(self,
                                            selector: #selector(playerItemDidReachEnd(notification:)),
                                            name: .AVPlayerItemDidPlayToEndTime,
                                            object: player.currentItem)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        loadingView.layer.addSublayer(playerLayer)
        

        player.play()
        
        loadingView.bounds.size.height = self.view.bounds.height - 10
        loadingView.bounds.size.width = tableView.bounds.width - 5
        
        loadingView.center = view.center
        loadingView.alpha = 0
        view.addSubview(loadingView)
        
        UIView.animate(withDuration: 0, delay: 0, options: [], animations: {
            self.loadingView.alpha = 1
        }) { (success) in
            
        }
    }
    
    func hideLoadingPage(){
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.loadingView.transform = CGAffineTransform(translationX: 0, y: 10)
        }) { (success) in
            UIView.animate(withDuration: 0.3) {
                self.loadingView.transform = CGAffineTransform(translationX: 0, y: -1000)
            }
        }
    }
    
    
    var coaches = [Coach]()
    
    @IBAction func coachBtn(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard(name: "CoachInfo", bundle: .main)
        
        let vc = sb.instantiateViewController(withIdentifier: "CoachTabBar") as! UITabBarController
        
        guard let id = Auth.auth().currentUser?.uid else{return}
        
        
        let ref = Coach.ref.child(id)
             ref.observeSingleEvent(of: .value) {[weak self] (snapshot) in
                   if snapshot.exists(){
                    self?.show(vc, sender: self)
                   }else{
                    vc.selectedIndex = 1
                    vc.tabBar.items![0].isEnabled = false
                    vc.title = "הרשמת מדריכים"
                    self?.show(vc, sender: self)
                }
                
        }
        
    }
    
    
    var player =  AVPlayer()
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    
  

    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        showLoadingScreen()


        Coach.ref.observe(.childAdded) {[weak self] (snapshot) in
           
            guard let dict = snapshot.value! as? [String:Any], let coach = Coach(dict: dict) else{return}

            self?.coaches.append(coach)

            self?.tableView.reloadData()
            
            self?.hideLoadingPage()
            
        }
        

        guard let id = Auth.auth().currentUser?.uid else{return}
        
        
        let ref = Coach.ref.child(id)
             ref.observeSingleEvent(of: .value) {[weak self] (snapshot) in
                   if snapshot.exists(){
                    self?.coachBtnOutlet.title = "הדף שלך"
                   }
        }
        
        
        searchBar.delegate = self
            
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let split = splitViewController, !split.isCollapsed{
            self.performSegue(withIdentifier: "details", sender: self.coaches)
        
        }
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white

        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = UIColor.white
        

        
    }
    
   

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrainingTypesTableViewCell

        // Configure the cell...
        cell.separatorInset = UIEdgeInsets.zero;

        let row = indexPath.row
        
        switch row {
        case 0:
            cell.trainingTypeImage.image = #imageLiteral(resourceName: "trx")
        case 1:
            cell.trainingTypeImage.image = #imageLiteral(resourceName: "קרוספיט")
        case 2:
            cell.trainingTypeImage.image = #imageLiteral(resourceName: "פונקציונאלי")
        case 3:
            cell.trainingTypeImage.image = #imageLiteral(resourceName: "בטן")
        case 4:
            cell.trainingTypeImage.image = #imageLiteral(resourceName: "אירובי")
        case 5:
            cell.trainingTypeImage.image = #imageLiteral(resourceName: "יוגה 2")
        case 6:
            cell.trainingTypeImage.image = #imageLiteral(resourceName: "יוגה")
        default:
            cell.trainingTypeImage.image = #imageLiteral(resourceName: "גומיות 3")
        }

        return cell
            

    }
    
    var coaches2 = [Coach]()
    var searchCoaches = [Coach]()
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "details", sender: coaches2)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //for the split controller
        if let indexPath = tableView.indexPathForSelectedRow{
            guard let nav = segue.destination as? UINavigationController, let dest = nav.viewControllers.first as? CoachesTableViewController
                
            else {
                return
            }
            
                    
            let row = indexPath.row
                        
            
            if row == 0{
                for coach in coaches{
                    for video in coach.video{
                        guard let kind = video["kind"] as? String else {
                            return
                        }
                        if kind.contains("TRX"){
                            coaches2.append(coach)
                            dest.title = "TRX"
                            break
                        }
                    }
                }
            }

            if row == 1{
                 for coach in coaches{
                    for video in coach.video{
                        guard let kind = video["kind"] as? String else {
                            return
                        }
                        if kind.contains("CrossFit"){
                            coaches2.append(coach)
                            dest.title = "CrossFit"
                            break
                        }
                    }
                }

            }
            if row == 2{
                 for coach in coaches{
                    for video in coach.video{
                        guard let kind = video["kind"] as? String else {
                            return
                        }
                        if kind.contains("פונקציונלי"){
                            coaches2.append(coach)
                            dest.title = "פונקציונלי"
                            break
                        }
                    }
                }

            }
            if row == 3{
                for coach in coaches{
                   for video in coach.video{
                       guard let kind = video["kind"] as? String else {
                           return
                       }
                    if kind.contains("בטן"){
                        coaches2.append(coach)
                        dest.title = "בטן"
                        break
                    }
                }
               }

            }
            if row == 4{
                 for coach in coaches{
                    for video in coach.video{
                        guard let kind = video["kind"] as? String else {
                            return
                        }
                        if kind.contains("אירובי"){
                            coaches2.append(coach)
                            dest.title = "אירובי"
                            break
                        }
                    }
                }

            }
            if row == 5{
                 for coach in coaches{
                    for video in coach.video{
                        guard let kind = video["kind"] as? String else {
                            return
                        }
                        if kind.contains("יוגה"){
                            coaches2.append(coach)
                            dest.title = "יוגה"
                            break                        }
                    }
                }

            }
            if row == 6{
                 for coach in coaches{
                    for video in coach.video{
                        guard let kind = video["kind"] as? String else {
                            return
                        }
                        if kind.contains("פילאטיס"){
                            coaches2.append(coach)
                            dest.title = "פילאטיס"
                            break
                        }
                    }
                }

            }
            if row == 7{
                 for coach in coaches{
                    for video in coach.video{
                        guard let kind = video["kind"] as? String else {
                            return
                        }
                        if kind.contains("גומיות"){
                            coaches2.append(coach)
                            dest.title = "גומיות"
                            break
                        }
                    }
                }

            }

            dest.coaches = coaches2
            coaches2.removeAll()
            
        }
        guard let nav = segue.destination as? UINavigationController, let dest = nav.viewControllers.first as? CoachesTableViewController else{return}

            if segue.identifier == "search"{
                guard let text = searchBar.text, text.count > 0  else {
                    return
                }
                
                for coach in coaches{
                    if coach.fullName.contains(text.lowercased()){
                        searchCoaches.append(coach)
                    }else{
                        
                    }
                }
                dest.coaches = searchCoaches
                dest.title = searchBar.text
                searchCoaches.removeAll()
            }
    }
        
    

}


extension TrainingTypesTableViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        performSegue(withIdentifier: "search", sender: searchCoaches)
        self.view.endEditing(true)
        searchBar.text = ""
    }
    
}



extension UITableViewController: LoginButtonDelegate{
    public func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
                    if error != nil {
                    return
                }

                let accesstoken = AccessToken.current
                guard let accessTokenString = accesstoken?.tokenString else {return}

                let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
                // assign credentials to firebase authentication
                Auth.auth().signIn(with: credentials, completion:  {
                    (user, err) in
                    if err != nil{
                        self.showError()
                    }
                    self.showSuccess()

                    Router.shared.chooseMainViewController()

                })


        }

    public func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            print("logout")
            do{
                try Auth.auth().signOut()
            }catch let err{
                print(err)
            }

        }

}

extension UITableViewController: GIDSignInDelegate{
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil{
            self.showError()
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

           print("logged in succeeded")
            Router.shared.chooseMainViewController()

        }

    }

    func googleFromLogout(){
        do{
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance()?.signOut()
        }catch let err{
            print("err",err)
        }
    }


}

