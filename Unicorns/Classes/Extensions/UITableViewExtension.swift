//
//  UITableViewExtension.swift
//  Alamofire
//
//  Created by Bartek Żabicki on 06.08.2018.
//

import UIKit

extension UITableView {
  
  ///Register given cell with reuseIdentifier and nibName equal to cell's name
  public func register<T: ReuseIdentifying>(reuseIdentifying: T.Type, bundle bundleName: String? = nil) {
    let bundle = bundleName != nil ? Bundle(identifier: bundleName!) : Bundle(for: T.self)
    let nibName = UINib(nibName: T.reuseIdentifier, bundle: bundle)
    register(nibName, forCellReuseIdentifier: T.reuseIdentifier)
  }
  
  ///Dequaue reusable cell with identifier equal to cell's name
  public func dequeueReusable<T: ReuseIdentifying>(cell: T.Type, for indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
    }
    return cell
  }
    
}
