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
  
  let wrongAnswerBanner = UIImageView(image: UIImage(named: "torn_banner"))

  let rightAnswerBanner = UIImageView(image: UIImage(named: "torn_banner"))
  
//  let congratulationsBanner = UIImageView(image: UIImage(named: "banner"))
//  let congratulationsLabel = UILabel()
//  
//  var madVaultBoyImage = UIImageView(image: UIImage(named: "vault boy_wrong"))
//  var thumbsUpVaultBoyImage = UIImageView(image: UIImage(named: "newVaultBoy"))
//  var congratulationsVaultBoyImage = UIImageView(image: UIImage(named: "vault boy_pipboy"))
//  var zeroScoreVaultBoyImage = UIImageView(image: UIImage(named: "vault boy_gameover"))
  
  let fireworks_2_gold = UIImageView(image: UIImage(named: "Gold_Fireworks"))
  
  let yellowBurst = UIImageView(image: UIImage(named:"Yellow_Speech_Bubble@3x"))
  
  let rightAnswerLabel = UILabel()
  let wrongAnswerLabel = UILabel()
//  let earnedPerkLabel = UILabel ()
  let survivedLabel = UILabel()
//  let perkLabel = UILabel ()
//  let failedLabel = UILabel ()
//  let totalScoreLabel = UILabel ()

  let messages = Messages(next: "", restart: "")


  init() {
    
    // add the wrong answer banner- it starts off hidden
    wrongAnswerBanner.hidden = true
    wrongAnswerBanner.frame = CGRect(x: 0, y: 100, width: 360, height: 60)
    
    // add the wrong answer label
    wrongAnswerLabel.frame = CGRect(x: 0, y: 0, width: wrongAnswerBanner.frame.size.width, height: wrongAnswerBanner.frame.size.height)
    wrongAnswerLabel.font = UIFont(name: "Overseer", size: 25)
    wrongAnswerLabel.textColor = UIColor.blackColor()
    wrongAnswerLabel.textAlignment = .Center
    
    // add the right answer banner- it starts off hidden
    rightAnswerBanner.hidden = true
    rightAnswerBanner.frame = CGRect(x: 80, y: 100, width: 200, height: 60)
    
    // add the right answer label
    rightAnswerLabel.frame = CGRect(x: 0, y: 0, width: rightAnswerBanner.frame.size.width, height: rightAnswerBanner.frame.size.height)
    rightAnswerLabel.font = UIFont(name: "Overseer", size: 25)
    rightAnswerLabel.textColor = UIColor.blackColor()
    rightAnswerLabel.textAlignment = .Center
    
    // add the congratulations banner
//    congratulationsBanner.hidden = true
//    congratulationsBanner.frame = CGRect(x: 40, y: 525, width: 300, height: 60)
    
    // add congratulations label
//    congratulationsLabel.frame = CGRect(x: 0, y: 0, width: congratulationsBanner.frame.size.width, height: congratulationsBanner.frame.size.height)
//    congratulationsLabel.font = font
//    congratulationsLabel.textColor = UIColor.blackColor()
//    congratulationsLabel.textAlignment = .Center
    
    // add fireworks
    fireworks_2_gold.alpha = 0.0
    fireworks_2_gold.frame = CGRect(x: 90, y: 80, width: 300,  height: 300)
   
    // add you survived! label
    survivedLabel.hidden = true
    survivedLabel.frame = CGRectMake(35, -60, 400, 400)
    survivedLabel.text = messages.youSurvivedMessage
    survivedLabel.shadowColor = UIColor.blackColor()
    survivedLabel.shadowOffset = CGSize(width: 2, height: 2)
    survivedLabel.font = UIFont(name: "Overseer", size: 30)
    survivedLabel.textColor = UIColor.whiteColor()
    
    // add yellowburst
    yellowBurst.alpha = 0.0
    yellowBurst.frame = CGRect(x: -285, y: -160, width: 900,  height: 900)
    
      }
}

