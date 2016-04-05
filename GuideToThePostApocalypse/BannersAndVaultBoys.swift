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
  
  let congratulationsBanner = UIImageView(image: UIImage(named: "banner"))
  let congratulationsLabel = UILabel()
  
  var madVaultBoyImage = UIImageView(image: UIImage(named: "vault boy_wrong"))
  var thumbsUpVaultBoyImage = UIImageView(image: UIImage(named: "newVaultBoy"))
  var congratulationsVaultBoyImage = UIImageView(image: UIImage(named: "vault boy_pipboy"))
  var zeroScoreVaultBoyImage = UIImageView(image: UIImage(named: "vault boy_gameover"))
  
  let fireworks_2_gold = UIImageView(image: UIImage(named: "Gold_Fireworks"))
  
  let yellowBurst = UIImageView(image: UIImage(named:"Yellow_Speech_Bubble@3x"))
  
  let rightAnswerLabel = UILabel()
  let wrongAnswerLabel = UILabel()
  let earnedPerkLabel = UILabel ()
  let survivedLabel = UILabel()
  let perkLabel = UILabel ()
  let failedLabel = UILabel ()
  let totalScoreLabel = UILabel ()

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
    
    //add the wrong answer mad vault boy
    madVaultBoyImage.hidden = true
    madVaultBoyImage.center = CGPoint(x: 180, y: 460)
    
    // add the right answer banner- it starts off hidden
    rightAnswerBanner.hidden = true
    rightAnswerBanner.frame = CGRect(x: 80, y: 100, width: 200, height: 60)
    
    
    // add the right answer label
    rightAnswerLabel.frame = CGRect(x: 0, y: 0, width: rightAnswerBanner.frame.size.width, height: rightAnswerBanner.frame.size.height)
    rightAnswerLabel.font = UIFont(name: "Overseer", size: 25)
    rightAnswerLabel.textColor = UIColor.blackColor()
    rightAnswerLabel.textAlignment = .Center
    
    
    //add the right answer thumbs up vault boy
    thumbsUpVaultBoyImage.hidden = true
    thumbsUpVaultBoyImage.center = CGPoint(x: 185, y: 460)
    
    
    // add the congratulations banner
    congratulationsBanner.hidden = true
    congratulationsBanner.frame = CGRect(x: 40, y: 525, width: 300, height: 60)
    
    
    // add congratulations label
    congratulationsLabel.frame = CGRect(x: 0, y: 0, width: congratulationsBanner.frame.size.width, height: congratulationsBanner.frame.size.height)
    congratulationsLabel.font = font
    congratulationsLabel.textColor = UIColor.blackColor()
    congratulationsLabel.textAlignment = .Center
    
    
    // add congratulations vault boy
    congratulationsVaultBoyImage.hidden = true
    congratulationsVaultBoyImage.center = CGPoint(x: 180, y: 360)
    
    // add fireworks
    fireworks_2_gold.alpha = 0.0
    fireworks_2_gold.frame = CGRect(x: 90, y: 80, width: 300,  height: 300)
   
    // add zeroScore vault boy
    zeroScoreVaultBoyImage.hidden = true
    zeroScoreVaultBoyImage.center = CGPoint(x: 180, y: 340)
    
    // add you earned a perk! label
    earnedPerkLabel.hidden = true
    earnedPerkLabel.frame = CGRectMake(50, -70, 400, 400)
    earnedPerkLabel.text = messages.youEarnedAPerkMessage
    earnedPerkLabel.shadowColor = UIColor.blackColor()
    earnedPerkLabel.shadowOffset = CGSize(width: 2, height: 2)
    earnedPerkLabel.font = UIFont(name: "Overseer", size: 40)
    earnedPerkLabel.textColor = UIColor.whiteColor()
    
    // add perk label
    perkLabel.hidden = true
    perkLabel.frame = CGRect(x: 125, y: 380, width: 200, height: 200)
    perkLabel.shadowColor = UIColor.blackColor()
    perkLabel.shadowOffset = CGSize(width: 2, height: 2)
    perkLabel.font = UIFont(name: "Overseer", size: 40)
    perkLabel.textColor = UIColor.whiteColor()
    
    
    // add you failed this round label
    failedLabel.hidden = true
    failedLabel.frame = CGRectMake(40, -20, 300, 300)
    failedLabel.text = messages.youFailedMessage
    failedLabel.shadowColor = UIColor.blackColor()
    failedLabel.shadowOffset = CGSize(width: 2, height: 2)
    failedLabel.font = UIFont(name: "Overseer", size: 40)
    failedLabel.textColor = UIColor.whiteColor()

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

