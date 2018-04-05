//
//  UIViewExtension.swift
//  CoCreate
//
//  Created by Bartek Żabicki on 20.03.2018.
//  Copyright © 2018 CoCreate. All rights reserved.
//

import UIKit

extension UIView {
  
  public func fadeIn(withDuration duration: Double = 0.2) {
    guard alpha == 0 else { return }
    UIView.animate(withDuration: TimeInterval(duration)) {
      self.alpha = 1
    }
  }
  
  public func fadeOut(withDuration duration: Double = 0.2) {
    guard alpha == 1 else { return }
    UIView.animate(withDuration: TimeInterval(duration)) {
      self.alpha = 0
    }
  }
  
  @IBInspectable open var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    } set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }
  
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
  
  @IBInspectable open var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    } set {
      layer.borderWidth = newValue
    }
  }
  
}
