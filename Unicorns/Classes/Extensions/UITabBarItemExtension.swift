//
//  UITabBarItemExtension.swift
//  Alamofire
//
//  Created by Bartek Żabicki on 25/09/2018.
//

import UIKit

extension UITabBarItem: XIBLocalizable {
  
  ///A key that is use to localize `title`
  @IBInspectable public var localizableKey: String? {
    get {
      return nil
    } set {
      title = newValue?.localized
    }
  }
  
}
