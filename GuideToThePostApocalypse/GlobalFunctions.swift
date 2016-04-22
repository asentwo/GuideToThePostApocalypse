//
//  GlobalFunctions.swift
//  Wastland_Survival_Guide
//
//  Created by Justin Doo on 1/16/16.
//  Copyright © 2016 Justin Doo. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
  
  
  //MARK: Delay View
  
  func delay(delay:Double, closure:()->()) {
    dispatch_after(
      dispatch_time(
        DISPATCH_TIME_NOW,
        Int64(delay * Double(NSEC_PER_SEC))
      ),
      dispatch_get_main_queue(), closure)
  }
  
  
  //MARK: Timer Ends Shake
  
  func timerShake () {
    let imageView = self.view
    let shakeAnimation = CABasicAnimation(keyPath: "position")
    shakeAnimation.duration = 0.07
    shakeAnimation.repeatCount = 10
    shakeAnimation.autoreverses = true
    shakeAnimation.fromValue = NSValue(CGPoint: CGPointMake(imageView.center.x - 10, imageView.center.y))
    shakeAnimation.toValue = NSValue(CGPoint: CGPointMake(imageView.center.x + 10, imageView.center.y))
    imageView.layer.addAnimation(shakeAnimation, forKey: "position")
  }
  
  
  //MARK: Random number generator - used for tile placement
  
  func randomNumber(minX minX:UInt32, maxX:UInt32) -> Int {
    let result = (arc4random() % (maxX - minX + 1)) + minX
    return Int(result)
  }
  
  
  //MARK: GifMaker
  
  func gifMaker (gif: String) {
    let Gif = UIImage.gifWithName("\(gif)")
    let View = UIImageView(image: Gif)
    View.hidden = false
    View.frame = CGRect(x: 35.0, y: 170.0, width: View.frame.size.width, height: View.frame.size.height)
    self.view.addSubview(View)
    self.view.sendSubviewToBack(View)
  }
  
  }
