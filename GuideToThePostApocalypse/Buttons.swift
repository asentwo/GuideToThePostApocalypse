//
//  Buttons.swift
//  Wastland_Survival_Guide
//
//  Created by Justin Doo on 1/25/16.
//  Copyright © 2016 Justin Doo. All rights reserved.
//

import Foundation
import UIKit

struct Buttons {
  
  let messages = Messages(next: "", restart: "")
  
  var nextRoundButton: UIButton!
  var tryAgainButton: UIButton!
  var restartButton: UIButton!
  var hintButton: UIButton!
  
  // add try again button
  let tryBtn = UIButton(frame: CGRect(x: 60, y: 530, width: 250, height: 50))
  
  // add next round button
  let btn = UIButton(frame: CGRect(x: 60, y: 480, width: 250, height: 50))
  
  // add restart game button
    let restartBtn = UIButton(frame: CGRect(x: 60, y: 530, width: 250, height: 50))
  
  //add hint button
  let hintBtn = UIButton(frame: CGRect(x: 10, y: 15, width: 60, height: 60))
  
  init () {
    
    tryBtn.hidden = true
    tryBtn.tag = 1
    tryBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    tryBtn.setBackgroundImage(UIImage(named: "yellow_button"), forState: .Normal)
    tryBtn.setTitle("\(messages.tryAgainMessage)", forState: UIControlState.Normal)
    tryBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
    tryBtn.titleLabel?.font = UIFont(name: "Overseer", size: 20)
    tryBtn.setTitleShadowColor(UIColor.blackColor(), forState: .Normal)
    tryAgainButton = tryBtn
    
    btn.hidden = true
    btn.tag = 1
    btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    btn.setBackgroundImage(UIImage(named: "yellow_button"), forState: .Normal)
    btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
    btn.titleLabel?.font = UIFont(name: "Overseer", size: 20)
    btn.setTitleShadowColor(UIColor.blackColor(), forState: .Normal)
    nextRoundButton = btn
    
    restartBtn.hidden = true
    restartBtn.tag = 1
    restartBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    restartBtn.setBackgroundImage(UIImage(named: "yellow_button"), forState: .Normal)
    restartBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
    restartBtn.titleLabel?.font = UIFont(name: "Overseer", size: 20)
    restartBtn.setTitleShadowColor(UIColor.blackColor(), forState: .Normal)
    restartButton = restartBtn

    hintBtn.tag = 2
    hintBtn.setBackgroundImage(UIImage(named: "black-ink-grunge-stamp-circle"), forState: .Normal)
    hintBtn.setTitle("Hint", forState: .Normal)
    hintBtn.titleLabel?.font = UIFont(name: "Overseer", size: 20)
    hintBtn.titleLabel?.alpha = 0.8
    hintBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    hintBtn.setTitleShadowColor(UIColor.blackColor(), forState: .Normal)
    hintBtn.enabled = false
    hintButton = hintBtn
  }
}