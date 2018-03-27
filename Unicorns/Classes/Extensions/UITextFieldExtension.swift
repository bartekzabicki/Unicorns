//
//  UITextFieldExtension.swift
//  Vanderon
//
//  Created by Sebastian Kruk on 13.12.2017.
//  Copyright © 2017 ready4s. All rights reserved.
//

import UIKit

extension UITextField: XIBLocalizable {
  
  @IBInspectable public var localizableKey: String? {
    get {
      return nil
    } set {
      placeholder = newValue?.localized
    }
  }
  
}
