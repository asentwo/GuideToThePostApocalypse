//
//  Graphics.swift
//  Wastland_Survival_Guide
//
//  Created by Justin Doo on 1/25/16.
//  Copyright © 2016 Justin Doo. All rights reserved.
//

import Foundation
import UIKit


struct BannersAndVaultBoys {
  
//  let wrongAnswerBanner = UIImageView(image: UIImage(named: "torn_banner"))
//  let rightAnswerBanner = UIImageView(image: UIImage(named: "torn_banner"))
  let fireworks_2_gold = UIImageView(image: UIImage(named: "Gold_Fireworks"))
  let yellowBurst = UIImageView(image: UIImage(named:"Yellow_Speech_Bubble@3x"))
//  let rightAnswerLabel = UILabel()
//  let wrongAnswerLabel = UILabel()
//  let messages = Messages(next: "", restart: "")

  init() {
    
//    // add the wrong answer banner- it starts off hidden
//    wrongAnswerBanner.hidden = true
//    wrongAnswerBanner.frame = CGRect(x: 0, y: 100, width: 360, height: 60)
//    
//    // add the wrong answer label
//    wrongAnswerLabel.frame = CGRect(x: 0, y: 0, width: wrongAnswerBanner.frame.size.width, height: wrongAnswerBanner.frame.size.height)
//    wrongAnswerLabel.font = UIFont(name: "Overseer", size: 25)
//    wrongAnswerLabel.textColor = UIColor.blackColor()
//    wrongAnswerLabel.textAlignment = .Center
//    
//    // add the right answer banner- it starts off hidden
//    rightAnswerBanner.hidden = true
//    rightAnswerBanner.frame = CGRect(x: 90, y: 100, width: 200, height: 60)
//    
//    // add the right answer label
//    rightAnswerLabel.frame = CGRect(x: 0, y: 0, width: rightAnswerBanner.frame.size.width, height: rightAnswerBanner.frame.size.height)
//    rightAnswerLabel.font = UIFont(name: "Overseer", size: 25)
//    rightAnswerLabel.textColor = UIColor.blackColor()
//    rightAnswerLabel.textAlignment = .Center
    
    // add fireworks
    fireworks_2_gold.alpha = 0.0
    fireworks_2_gold.frame = CGRect(x: 60, y: 60, width: 400,  height: 400)
    
    // add yellowburst
    yellowBurst.alpha = 0.0
    yellowBurst.frame = CGRect(x: -285, y: -160, width: 900,  height: 900)
    
      }
}

