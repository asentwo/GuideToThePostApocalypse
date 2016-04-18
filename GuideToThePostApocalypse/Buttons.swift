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
  
  //add hint button
  let hintBtn = UIButton(frame: CGRect(x: 10, y: 15, width: 60, height: 60))
  
  init () {
    


    hintBtn.tag = 2
    hintBtn.setBackgroundImage(UIImage(named: "black-ink-grunge-stamp-circle"), forState: .Normal)
    hintBtn.setTitle("Hint", forState: .Normal)
    hintBtn.titleLabel?.font = UIFont(name: "Overseer", size: 20)
    hintBtn.titleLabel?.alpha = 0.8
    hintBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    hintBtn.setTitleShadowColor(UIColor.blackColor(), forState: .Normal)
    hintBtn.enabled = false
  }
}