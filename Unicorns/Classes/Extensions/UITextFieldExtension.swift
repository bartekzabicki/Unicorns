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
      placeholder = newValue?.localized
    }
  }
  
  @IBInspectable public var placeHolderColor: UIColor? {
    get {
      return nil
    } set {
      attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder!.localized : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
    }
  }
  
  @IBInspectable public var isUppercased: Bool {
    get {
      return false
    } set {
      if newValue {
        placeholder = placeholder?.uppercased()
      } else {
        placeholder = placeholder?.localized
      }
    }
  }
  
  private func localizedWithColor(placeholder: String?) {
    if let placeHolderColor = placeHolderColor {
      attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: placeHolderColor])
    } else {
      self.placeholder = placeholder
    }
  }
  
}
