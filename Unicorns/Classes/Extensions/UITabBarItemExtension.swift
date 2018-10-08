//
//  UITabBarItemExtension.swift
//  Alamofire
//
//  Created by Bartek Żabicki on 25/09/2018.
//

import UIKit

extension UITabBarItem: XIBLocalizable {
  
  @IBInspectable public var localizableKey: String? {
    get {
      return nil
    } set {
      title = newValue?.localized
    }
  }
  
}
