//
//  GameScore.swift
//  Wastland_Survival_Guide
//
//  Created by Justin Doo on 1/21/16.
//  Copyright © 2016 Justin Doo. All rights reserved.
//

import Foundation


class GameScore {
  //store the user's game achievement
  var points:Int = 0 {
    didSet {
      //custom setter - keep the score positive
      points = max(points, 0)
    }
  }
}