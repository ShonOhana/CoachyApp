//
//  ThreePointGardientView.swift
//  CoachyFitApp
//
//  Created by Mac on 23/05/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

@IBDesignable
class ThreePointGardientView: UIView {

    @IBInspectable var firstColor = UIColor.white{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var secondColor = UIColor.black{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var thirdColor = UIColor.white{
        didSet{
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }

    func updateView(){
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor.cgColor , secondColor.cgColor, thirdColor.cgColor]
        
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
    }

}
