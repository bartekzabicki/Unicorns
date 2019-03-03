//
//  UIViewExtension.swift
//  CoCreate
//
//  Created by Bartek Żabicki on 20.03.2018.
//  Copyright © 2018 CoCreate. All rights reserved.
//

import UIKit

extension UIView {
  
  ///Initialize view from nib with given name
  public static func loadFromNib<T: ReuseIdentifying>(view: T.Type) -> T {
    guard let view = UINib(nibName: T.reuseIdentifier, bundle: nil).instantiate(withOwner: self, options: nil).first as? T else {
      fatalError("Cannot initialize view with nibName \(T.reuseIdentifier)")
    }
    return view
  }
  
  /**
  Shows view with duration
  - Parameter duration: The duration of fading, default value is 0.2
 */
  public func fadeIn(withDuration duration: Double = 0.2) {
    guard alpha == 0 else { return }
    UIView.animate(withDuration: TimeInterval(duration)) {
      self.alpha = 1
    }
  }
  
  /**
   Hides view with duration
   - Parameter duration: The duration of fading, default value is 0.2
   */
  public func fadeOut(withDuration duration: Double = 0.2) {
    guard alpha == 1 else { return }
    UIView.animate(withDuration: TimeInterval(duration)) {
      self.alpha = 0
    }
  }
  
  ///Corner radius of the view, sets values and maskToBounds on layer
  @IBInspectable open var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    } set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }
  
  ///Border color of the view, sets color on layer
  @IBInspectable open var borderColor: UIColor? {
    get {
      if let borderColor = layer.borderColor {
        return UIColor(cgColor: borderColor)
      }
      return nil
    } set {
      layer.borderColor = newValue?.cgColor
    }
  }
  
  ///Border width color of the view, sets width on layer
  @IBInspectable open var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    } set {
      layer.borderWidth = newValue
    }
  }
  
  ///Convenience property, sets view's alpha to 0 or 1, depending on Bool value
  @IBInspectable open var isFaded: Bool {
    get {
      return alpha == 0
    } set {
      alpha = newValue ? 0 : 1
    }
  }
  
}
