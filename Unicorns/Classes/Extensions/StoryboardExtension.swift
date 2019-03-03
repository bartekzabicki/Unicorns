//
//  StoryboardExtension.swift
//  Alamofire
//
//  Created by Bartłomiej Zabicki on 03/03/2019.
//

import UIKit

extension UIStoryboard {
  
  ///Instantiate viewController with identifier equal to controller's name
  public func instantiateViewController<T: ReuseIdentifying>(type: T.Type) -> T {
    guard let viewController = instantiateViewController(withIdentifier: T.reuseIdentifier) as? T else {
      fatalError("Could not dequeue viewController with identifier: \(T.reuseIdentifier)")
    }
    return viewController
  }
  
  public func instantiateViewControllerWith(reuseIdentifier: String) -> UIViewController {
    return instantiateViewController(withIdentifier: reuseIdentifier)
  }
  
}
