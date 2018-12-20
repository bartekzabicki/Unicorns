//
//  UITextFieldExtension.swift
//  Vanderon
//
//  Created by Sebastian Kruk on 13.12.2017.
//  Copyright © 2017 ready4s. All rights reserved.
//

import UIKit

extension UITextField: XIBLocalizable {
  
  ///A key that is use to localize `placeholder`
  @IBInspectable public var localizableKey: String? {
    get {
      return nil
    } set {
      if let placeHolderColor = placeHolderColor {
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? newValue!.localized : "", attributes:[NSAttributedString.Key.foregroundColor: placeHolderColor])
      } else {
        placeholder = newValue?.localized
      }
    }
  }
  
  @IBInspectable var placeHolderColor: UIColor? {
    get {
      return nil
    } set {
      attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder!.localized : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
    }
  }
  
}
