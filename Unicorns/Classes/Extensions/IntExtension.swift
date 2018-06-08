//
//  IntExtension.swift
//  CompanyManager
//
//  Created by Bartek on 09.04.2017.
//  Copyright © 2017 zabicki. All rights reserved.
//

import UIKit

extension Int {
  
  public func asRadian() -> CGFloat {
    return (CGFloat(self) * CGFloat(Double.pi) / 180.0)
  }
  
}
