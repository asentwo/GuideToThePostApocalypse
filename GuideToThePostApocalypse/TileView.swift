//
//  Round3_TileView.swift
//  Wastland_Survival_Guide
//
//  Created by Justin Doo on 12/31/15.
//  Copyright © 2015 Justin Doo. All rights reserved.
//

import Foundation
import UIKit

//makes the view controller a delegate to all tiles so it can accept notifications from tiles when they are dropped somewhere on the board - extention is on viewcontroller.
protocol TileDragDelegateProtocol {
  func tileView(tileView: TileView, didDragToPoint: CGPoint)
}

//1
class TileView:UIImageView {
  
  //2
  var letter: Character
  
  //3
  var isMatched: Bool = false
  
  private var xOffset: CGFloat = 0.0
  private var yOffset: CGFloat = 0.0
  
  var dragDelegate: TileDragDelegateProtocol?
  
  private var tempTransform: CGAffineTransform = CGAffineTransformIdentity
  
  //4 this should never be called
  required init(coder aDecoder:NSCoder) {
    fatalError("use init(letter:, sideLength:")
  } 
  
  //5 create a new tile for a given letter
  init(letter:Character, sideLength:CGFloat) {
    self.letter = letter
    
    //the tile background
    let image = UIImage(named: "tile")!
    
    //superclass initializer
    //references to superview's "self" must take place after super.init
    super.init(image:image)
    
    //6 resize the tile
    let scale = sideLength / image.size.width
    self.frame = CGRect(x: 0, y: 0, width: image.size.width * scale, height: image.size.height * scale)
    
    //add a letter on top
    let letterLabel = UILabel(frame: self.bounds)
    letterLabel.textAlignment = NSTextAlignment.Center
    letterLabel.textColor = UIColor.whiteColor()
    letterLabel.backgroundColor = UIColor.clearColor()
    letterLabel.text = String(letter).uppercaseString
    letterLabel.font = UIFont(name: "Overseer", size: 78.0*scale)
    self.addSubview(letterLabel)
    
    //MARK: make tiles dragable
    self.userInteractionEnabled = true
    
    //create the tile shadow
    self.layer.shadowColor = UIColor.blackColor().CGColor
    self.layer.shadowOpacity = 0
    self.layer.shadowOffset = CGSizeMake(10.0, 10.0)
    self.layer.shadowRadius = 15.0
    self.layer.masksToBounds = false
    
    let path = UIBezierPath(rect: self.bounds)
    self.layer.shadowPath = path.CGPath
    
     }
  
  //1
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    let point = touch.locationInView(self.superview)
    xOffset = point.x - self.center.x
    yOffset = point.y - self.center.y
      
      //show the drop shadow
      self.layer.shadowOpacity = 0.8
    
    //save the current transform
    tempTransform = self.transform
    
      //enlarge the tile when picked up
      self.transform = CGAffineTransformScale(self.transform, 1.2, 1.2)
      //makes it so the tiles don't overlap
      self.superview?.bringSubviewToFront(self)
      
    }

  //2
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    let point = touch.locationInView(self.superview)
    self.center = CGPointMake(point.x - xOffset, point.y - yOffset)
  }
  
  //3
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    self.touchesMoved(touches, withEvent: event)
    
    //restore the original transform
    self.transform = tempTransform
    dragDelegate?.tileView(self, didDragToPoint: self.center)
    self.layer.shadowOpacity = 0.0
    //decrease tile to original size
    self.transform = CGAffineTransformScale(self.transform, 1.0, 1.0)
  }
  
  
  //reset the view transform in case drag is cancelled
  override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
      self.transform = tempTransform
    //self.transform = CGAffineTransformScale(self.transform, 1.0, 1.0)
    self.layer.shadowOpacity = 0.0
  }
}