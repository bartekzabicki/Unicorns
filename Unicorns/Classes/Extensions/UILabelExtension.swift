//
//  UILabelExtension.swift
//  Vanderon
//
//  Created by Bartek Żabicki on 13.12.2017.
//  Copyright © 2017 ready4s. All rights reserved.
//

import UIKit

extension UILabel: XIBLocalizable {
  
  ///A key that is use to localize `text`
  @IBInspectable public var localizableKey: String? {
    get {
      return nil
    } set {
      text = newValue?.localized
    }
  }
  
}
