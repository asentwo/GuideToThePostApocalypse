//
//  Round3_Particles.swift
//  Wastland_Survival_Guide
//
//  Created by Justin Doo on 1/8/16.
//  Copyright © 2016 Justin Doo. All rights reserved.
//

import Foundation
import UIKit

class TileBackgroundExplode: UIView {
  //1
  private var emitter:CAEmitterLayer!
  
  //2 configure the UIView to have an emitter layer
  override class func layerClass() -> AnyClass {
    return CAEmitterLayer.self
  }
  
  required init(coder aDecoder:NSCoder) {
    fatalError("use init(frame:")
  }
  
  override init(frame:CGRect) {
    super.init(frame:frame)
    
    //initialize the emitter
    emitter = self.layer as! CAEmitterLayer
    emitter.emitterPosition = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
    emitter.emitterSize = self.bounds.size
    emitter.emitterMode = kCAEmitterLayerAdditive
    emitter.emitterShape = kCAEmitterLayerRectangle
  }
  
  
  override func didMoveToSuperview() {
    //1
    super.didMoveToSuperview()
    if self.superview == nil {
      return
    }
    
    //2
    let texture:UIImage? = UIImage(named:"particle")
    assert(texture != nil, "particle image not found")
    
    //3 - used to emit particles
    let emitterCell = CAEmitterCell()
    
    //4 - uses the texture of the image for the particle
    emitterCell.contents = texture!.CGImage
    
    //5 - The name will be used later to modify the emitter layer’s properties via key-value coding
    emitterCell.name = "cell"
    
    //6 - intesity and lifetime of particles
    emitterCell.birthRate = 500
    emitterCell.lifetime = 0.75
    
    //7 - the blueRange sets a random color- in this case between white and orange, the negative bluespeed causes the intesity of the color to drop over time
    emitterCell.blueRange = 0.33
    emitterCell.blueSpeed = -0.33
    
    //8 - spread of partcles
    emitterCell.velocity = 120
    emitterCell.velocityRange = 20
    
    //9 - default scale is 1, by setting to 0.5 the scale will change between 1 - 1.5, the negative scale speed will cause the particles to shrink over time
    emitterCell.scaleRange = 0.5
    emitterCell.scaleSpeed = -0.2
    
    //10 -Here you set a range (an angle) for the direction the emitter will emit the cells. You set it to a range of 360 degrees – that is, to randomly emit particles in all directions. Remember, this function takes its value in radians, not degrees, so 2*pi radians
    emitterCell.emissionRange = CGFloat(M_PI*2)
    
    //11 - add the cell you created to the emitter layer. emitterCells is an array of CAEmitterCells for this emitter. (You can have more than one.)
    emitter.emitterCells = [emitterCell]
    
    //disable the emitter
    var delay = Int64(0.1 * Double(NSEC_PER_SEC))
    var delayTime = dispatch_time(DISPATCH_TIME_NOW, delay)
    dispatch_after(delayTime, dispatch_get_main_queue()) {
      self.disableEmitterCell()
    }
    
    //remove explosion view
    delay = Int64(2 * Double(NSEC_PER_SEC))
    delayTime = dispatch_time(DISPATCH_TIME_NOW, delay)
    dispatch_after(delayTime, dispatch_get_main_queue()) {
      self.removeFromSuperview()
    }
  }
  
  func disableEmitterCell() {
    emitter.setValue(0, forKeyPath: "emitterCells.cell.birthRate")
  }
}