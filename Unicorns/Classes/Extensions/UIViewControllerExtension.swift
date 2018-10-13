//
//  UIViewControllerExtension.swift
//  CompanyManager
//
//  Created by Bartek Żabicki on 25.03.2018.
//  Copyright © 2018 bartekzabicki. All rights reserved.
//

import UIKit

extension UIViewController {
  
  
  public func hideNavigationBar() {
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  public func showNavigationBar() {
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  /**
   Function that sets given title and color to back arrow
   - Parameters:
   - title: The title that should appear
   - color: The color of back arrow. By defaults it's purple
 */
  public func setupBackArrow(with title: String = "", color: UIColor = #colorLiteral(red: 0.4040000141, green: 0.4199999869, blue: 0.5839999914, alpha: 1)) {
    navigationItem.backBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
    navigationController?.navigationBar.tintColor = color
  }
  
  ///Hides keyboard by calling endEditing(animated: true) on view
  @objc public func hideKeyboard() {
    view.endEditing(true)
  }
  
}
