//
//  UIButtonExtension.swift
//  CoCreate
//
//  Created by Bartek Żabicki on 27.02.2018.
//  Copyright © 2018 CoCreate. All rights reserved.
//

import UIKit

protocol XIBLocalizable {
  var localizableKey: String? { get set }
}

extension UIButton: XIBLocalizable {
  
  @IBInspectable var localizableKey: String? {
    get {
      return nil
    } set {
      setTitle(newValue?.localized, for: .normal)
    }
  }
}
