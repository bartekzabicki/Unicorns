//
//  CGSizeExtension.swift
//  Pods-Unicorns_Tests
//
//  Created by Bartek Żabicki on 15.05.2018.
//

import UIKit

extension CGSize {
  
  ///Compare two CGSize's
  public static func > (lhs: CGSize, rhs: CGSize) -> Bool {
    return lhs.width > rhs.width || lhs.height > rhs.height
  }

}
