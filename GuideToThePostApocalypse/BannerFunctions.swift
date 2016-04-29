//
//  BannerFunctions.swift
//  Wastland_Survival_Guide
//
//  Created by Justin Doo on 1/25/16.
//  Copyright © 2016 Justin Doo. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {

  
  //MARK: ShowCongratulationsBanner()
  
  func ShowCongratulationsBanner(banner: UIImageView, label: UILabel) {
    UIView.transitionWithView(banner, duration: 0.33, options: [.CurveEaseOut, .TransitionFlipFromLeft], animations: {
      banner.hidden = false
      label.hidden = false
      label.text = "You scored \(totalScore) points!"
      }, completion:nil)
  }
}
