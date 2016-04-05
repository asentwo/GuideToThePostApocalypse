//
//  Round1_Graphics.swift
//  Wastland_Survival_Guide
//
//  Created by Justin Doo on 12/16/15.
//  Copyright © 2015 Justin Doo. All rights reserved.
//

import Foundation
import UIKit



extension Round1_ViewController {
  
  //MARK: Graphics
  
  func AddAllGraphics() {
    
    // add fireworks
    fireworks_2_gold.alpha = 0.0
    fireworks_2_gold.frame = CGRect(x: -20, y: 90, width: 300,  height: 300)
    self.view.addSubview(fireworks_2_gold)
    
    // add the wrong answer banner- it starts off hidden
    wrongAnswerBanner.hidden = true
    wrongAnswerBanner.frame = CGRect(x: 0, y: 100, width: 360, height: 60)
    self.view.addSubview(wrongAnswerBanner)
    
    // add the wrong answer label
    wrongAnswerLabel.frame = CGRect(x: 0, y: 0, width: wrongAnswerBanner.frame.size.width, height: wrongAnswerBanner.frame.size.height)
    wrongAnswerLabel.font = UIFont(name: "Overseer", size: 25)
    wrongAnswerLabel.textColor = UIColor.blackColor()
    wrongAnswerLabel.textAlignment = .Center
    wrongAnswerBanner.addSubview(wrongAnswerLabel)
    
    //add the wrong answer mad vault boy
    madVaultBoyImage.hidden = true
    madVaultBoyImage.center = CGPoint(x: 180, y: 450)
    self.view.addSubview(madVaultBoyImage)
    
    // add the right answer banner- it starts off hidden
    rightAnswerBanner.hidden = true
    rightAnswerBanner.frame = CGRect(x: 80, y: 100, width: 200, height: 60)
    self.view.addSubview(rightAnswerBanner)
    
    // add the right answer label
    rightAnswerLabel.frame = CGRect(x: 0, y: 0, width: rightAnswerBanner.frame.size.width, height: rightAnswerBanner.frame.size.height)
    rightAnswerLabel.font = UIFont(name: "Overseer", size: 25)
    rightAnswerLabel.textColor = UIColor.blackColor()
    rightAnswerLabel.textAlignment = .Center
    rightAnswerBanner.addSubview(rightAnswerLabel)
    
    //add the right answer thumbs up vault boy
    thumbsUpVaultBoyImage.hidden = true
    thumbsUpVaultBoyImage.center = CGPoint(x: 180, y: 450)
    view.addSubview(thumbsUpVaultBoyImage)
    
    // add the congratulations banner
    congratulationsBanner.hidden = true
    congratulationsBanner.frame = CGRect(x: 40, y: 525, width: 300, height: 60)
    self.view.addSubview(congratulationsBanner)
    
    // add congratulations label
    congratulationsLabel.frame = CGRect(x: 0, y: 0, width: congratulationsBanner.frame.size.width, height: congratulationsBanner.frame.size.height)
    congratulationsLabel.font = font
    congratulationsLabel.textColor = UIColor.blackColor()
    congratulationsLabel.textAlignment = .Center
    congratulationsBanner.addSubview(congratulationsLabel)
    
    // add congratulations vault boy
    congratulationsVaultBoyImage.hidden = true
    congratulationsVaultBoyImage.center = CGPoint(x: 180, y: 340)
    self.view.addSubview(congratulationsVaultBoyImage)
    
    // add try again button
    let tryBtn = UIButton(frame: CGRect(x: 60, y: 530, width: 250, height: 50))
    tryBtn.hidden = true
    tryBtn.tag = 1
    tryBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    tryBtn.setBackgroundImage(UIImage(named: "yellow_button"), forState: .Normal)
    tryBtn.setTitle("\(self.tryAgainMessage)", forState: UIControlState.Normal)
    tryBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
    tryBtn.addTarget(self, action: "restartViewController", forControlEvents: .TouchUpInside)
    self.view.addSubview(tryBtn)
    tryAgainButton = tryBtn
    
    // add zeroScore vault boy
    zeroScoreVaultBoyImage.hidden = true
    zeroScoreVaultBoyImage.center = CGPoint(x: 180, y: 340)
    self.view.addSubview(zeroScoreVaultBoyImage)
    
    // add you earned a perk! label
    earnedPerkLabel.hidden = true
    earnedPerkLabel.frame = CGRectMake(50, -70, 400, 400)
    earnedPerkLabel.text = youEarnedAPerkMessage
    earnedPerkLabel.shadowColor = UIColor.blackColor()
    earnedPerkLabel.shadowOffset = CGSize(width: 1, height: 1)
    earnedPerkLabel.font = UIFont(name: "Overseer", size: 40)
    earnedPerkLabel.textColor = UIColor.whiteColor()
    self.view.addSubview(earnedPerkLabel)
    
    // add perk strength label
    perkLabel.hidden = true
    perkLabel.frame = CGRect(x: 125, y: 380, width: 200, height: 200)
    perkLabel.text = perkMessage
    perkLabel.shadowColor = UIColor.blackColor()
    perkLabel.shadowOffset = CGSize(width: 1, height: 1)
    perkLabel.font = UIFont(name: "Overseer", size: 40)
    perkLabel.textColor = UIColor.whiteColor()
    self.view.addSubview(perkLabel)

    //add total score label
    self.totalScoreLabel.hidden = true
    self.totalScoreLabel.frame = CGRect(x: 110, y: 570, width: 200, height: 50)
    self.totalScoreLabel.shadowColor = UIColor.blackColor()
    self.totalScoreLabel.shadowOffset = CGSize(width: 1, height: 1)
    self.totalScoreLabel.font = font
    self.totalScoreLabel.textColor = UIColor.whiteColor()
    self.view.addSubview(self.totalScoreLabel)

    // add you failed this round label
    failedLabel.hidden = true
    failedLabel.frame = CGRectMake(40, -20, 300, 300)
    failedLabel.text = youFailedMessage
    failedLabel.shadowColor = UIColor.blackColor()
    failedLabel.shadowOffset = CGSize(width: 1, height: 1)
    failedLabel.font = UIFont(name: "Overseer", size: 40)
    failedLabel.textColor = UIColor.whiteColor()
    self.view.addSubview(failedLabel)
    
    // add next round button
    let btn = UIButton(frame: CGRect(x: 60, y: 530, width: 250, height: 50))
    btn.hidden = true
    btn.tag = 1
    btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    btn.setBackgroundImage(UIImage(named: "yellow_button"), forState: .Normal)
    btn.setTitle("\(self.nextRoundMessage)", forState: UIControlState.Normal)
    btn.setTitleColor(UIColor.blueColor(), forState: .Normal)
    btn.addTarget(self, action: "switchToRoundTwo:", forControlEvents: .TouchUpInside)
    self.view.addSubview(btn)
    nextRoundButton = btn
    

    
  }
}
 