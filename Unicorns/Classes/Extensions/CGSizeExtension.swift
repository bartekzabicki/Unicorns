//
//  CGSizeExtension.swift
//  Pods-Unicorns_Tests
//
//  Created by Bartek Żabicki on 15.05.2018.
//

import UIKit

extension CGSize: Equatable {
  
  static func == (lhs: CGSize, rhs: CGSize) -> Bool {
    return lhs.width == rhs.width && lhs.height == rhs.height
  }
  
  static func > (lhs: CGSize, rhs: CGSize) -> Bool {
    return lhs.width > rhs.width || lhs.height > rhs.height
  }
  
}
