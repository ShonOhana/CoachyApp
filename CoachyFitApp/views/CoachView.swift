//
//  CoachView.swift
//  CoachyFitApp
//
//  Created by Mac on 30/05/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class CoachView: UIView{

    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var coachNameLabel: UILabel!
    @IBOutlet weak var coachProfileImage: UIImageView!
    @IBOutlet weak var seniorityLabel: UILabel!
    @IBOutlet weak var specializeLabel: UILabel!
        
    @IBOutlet weak var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("CoachView", owner: self, options: nil)
        addSubview(self.view)
        self.view.frame = self.bounds
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.translatesAutoresizingMaskIntoConstraints = true
    }
    
    

}
