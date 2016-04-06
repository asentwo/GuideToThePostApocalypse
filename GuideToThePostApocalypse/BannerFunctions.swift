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
  
  
  //MARK: ShowWrongAnswerBanner()
  
  func ShowWrongAnswerBanner(banner: UIImageView, label: UILabel, message: String) {
    UIView.transitionWithView(banner, duration: 0.33, options: [.CurveEaseOut, .TransitionFlipFromLeft], animations: {
      banner.hidden = false
      label.text = message
      }, completion: {_ in
        UIView.animateWithDuration(0.33, delay: 0.7, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
          banner.center.x += self.view.frame.size.width
          //makes banner fly off screen at end of animation
          }, completion: {_ in
            banner.hidden = true
            banner.center.x -= self.view.frame.size.width
            // changes position of banner from off screen back onto screen & invisible so can be used again
          }
        )}
    )}
  
  
  //MARK: ShowRightAnswerBanner()
  
  func ShowRightAnswerBanner(banner: UIImageView, label: UILabel, message: String) {
    UIView.transitionWithView(banner, duration: 0.33, options: [.CurveEaseOut, .TransitionFlipFromLeft], animations: {
      banner.hidden = false
      label.text = message
      }, completion: {_ in
        UIView.animateWithDuration(0.33, delay: 0.7, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
          banner.center.x += self.view.frame.size.width
          //makes banner fly off screen at end of animation
          }, completion: {_ in
            banner.hidden = true
            banner.center.x -= self.view.frame.size.width
            // changes position of banner from off screen back onto screen & invisible so can be used again
          }
        )}
    )}

  
  //MARK: ShowCongratulationsBanner()
  
  func ShowCongratulationsBanner(banner: UIImageView, label: UILabel) {
    UIView.transitionWithView(banner, duration: 0.33, options: [.CurveEaseOut, .TransitionFlipFromLeft], animations: {
      banner.hidden = false
      label.hidden = false
      label.text = "You scored \(totalScore) points!"
      }, completion:nil)
  }
}
