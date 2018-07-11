//
//  UIViewControllerExtension.swift
//  CompanyManager
//
//  Created by Bartek Żabicki on 25.03.2018.
//  Copyright © 2018 bartekzabicki. All rights reserved.
//

import UIKit

extension UIViewController {
  
  public func hideNavigationController() {
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  public func showNavigationController() {
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  public func setupBackArrow(with title: String = "", color: UIColor = #colorLiteral(red: 0.4040000141, green: 0.4199999869, blue: 0.5839999914, alpha: 1)) {
    navigationItem.backBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
    navigationController?.navigationBar.tintColor = color
  }
  
  @objc public func hideKeyboard() {
    view.endEditing(true)
  }
  
}
