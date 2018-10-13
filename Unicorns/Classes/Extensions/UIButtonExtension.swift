//
//  UIButtonExtension.swift
//  CoCreate
//
//  Created by Bartek Żabicki on 27.02.2018.
//  Copyright © 2018 CoCreate. All rights reserved.
//

import UIKit

public protocol XIBLocalizable {
  var localizableKey: String? { get set }
}

extension UIButton: XIBLocalizable {
  
  ///A key that is use to localize `title`
  @IBInspectable public var localizableKey: String? {
    get {
      return nil
    } set {
      setTitle(newValue?.localized, for: .normal)
    }
  }
}
