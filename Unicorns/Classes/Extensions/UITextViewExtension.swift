//
//  PlaceholderTextView.swift
//  CompanyManager
//
//  Created by Bartek Żabicki on 16.08.2018.
//  Copyright © 2018 bartekzabicki. All rights reserved.
//

import UIKit

extension UITextView: UITextViewDelegate {
  
  // MARK: - Properties
  
  static private let placeholderTag: Int = 1001
  
  override open var bounds: CGRect {
    didSet {
      resizePlaceholder()
    }
  }
  
  private var placeholderLabel: UILabel? {
    return viewWithTag(UITextView.placeholderTag) as? UILabel
  }
  
  ///A key that is use to localize `placeholder`
  @IBInspectable open var localizableKey: String? {
    get {
      return nil
    } set {
      placeholder = newValue?.localized
    }
  }
  
  @IBInspectable open var placeholder: String? {
    get {
      return placeholderLabel?.text
    }
    set {
      if let placeholderLabel = placeholderLabel {
        placeholderLabel.text = newValue
        placeholderLabel.sizeToFit()
      } else {
        addPlaceholder(newValue)
      }
    }
  }
  
  // MARK: - Functions
  
  @objc private func textDidChange(_ sender: NSNotification) {
    guard let _ = sender.object as? UITextView else { return }
    reloadPlaceholderStatus()
  }
  
  ///Adjusts placeholderLabel's frame to current frame of UITextView
  public func resizePlaceholder() {
    if let placeholderLabel = placeholderLabel {
      let labelX = textContainerInset.left + 4
      let labelY = textContainerInset.top - 2
      let labelWidth = frame.width - (labelX * 2)
      let labelHeight = placeholderLabel.frame.height
      
      placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
    }
  }
  
  private func addPlaceholder(_ placeholderText: String?) {
    guard let placeholderText = placeholderText else { return }
    let newPlaceholderLabel = UILabel()
    
    newPlaceholderLabel.text = placeholderText
    newPlaceholderLabel.sizeToFit()
    
    newPlaceholderLabel.font = font
    newPlaceholderLabel.textColor = UIColor.lightGray
    newPlaceholderLabel.tag = UITextView.placeholderTag
    
    newPlaceholderLabel.isHidden = text.count > 0
    
    addSubview(newPlaceholderLabel)
    resizePlaceholder()
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(textDidChange),
                                           name: UITextView.textDidChangeNotification,
                                           object: nil)
  }
  
  public func reloadPlaceholderStatus() {
    placeholderLabel?.isHidden = !text.isEmpty
  }
  
}
