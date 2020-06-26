//
//  CoachesTableViewController.swift
//  CoachyFitApp
//
//  Created by Mac on 14/05/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import SDWebImage
import PKHUD
import AVKit

class CoachesTableViewController: UITableViewController {

    @IBOutlet weak var navTitle: UINavigationItem!
    var coaches = [Coach]()
    var kinds = ["TRX","CrossFit","פונקציונלי","בטן","אירובי","יוגה","פילאטיס","גומיות","אחר"]
    var clickedPath: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
                
    }
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return coaches.count
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as? CoachTableViewCell

        // Configure the cell...

        let row = indexPath.row
        
        cell?.separatorInset = UIEdgeInsets.zero;
        cell?.delegate = self
        cell?.videoDelegate = self
        
        guard let title = title else {
            return cell!
        }
        
        if kinds.contains(title){
           cell?.populate(with: self.coaches[row], indexPath: indexPath, title: title)
        }else{
            cell?.populateForSearch(with: coaches, indexPath: indexPath, name: title)
        }
        
        
        

        
        return cell!

    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = clickedPath{

            guard let dest = segue.destination as? CoachForClientViewController
                else{
                    return
                }
            dest.coach = coaches[indexPath.row]
            
            dest.videosArray = dest.coach.getFirstVideos(coach: dest.coach)

               
            }
        }
            
    }
    



extension CoachesTableViewController: myTableDelegate{
    func coachPageDelegate(_ cell: UITableViewCell) {
        if let indexPath = self.tableView.indexPath(for: cell){
            clickedPath = indexPath
            
            
                performSegue(withIdentifier: "toCoachPage", sender: Any.self)
            
        }
    }

    func videoDelegate(_ cell: UITableViewCell) {
                if let indexPath = self.tableView.indexPath(for: cell){
                clickedPath = indexPath
                    let videoString = coaches[clickedPath!.row].video[0]["uri"]
                let videoUrl = URL(string: videoString as! String)

                let player = AVPlayer(url: videoUrl!)
                let vcPlayer = AVPlayerViewController()
                vcPlayer.player = player
                self.present(vcPlayer, animated: true, completion: nil)
            }
    }

}
