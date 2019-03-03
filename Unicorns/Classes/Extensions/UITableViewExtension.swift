//
//  UITableViewExtension.swift
//  Alamofire
//
//  Created by Bartek Żabicki on 06.08.2018.
//

import Foundation

extension UITableView {
  
  ///Register given cell with reuseIdentifier and nibName equal to cell's name
  public func register<T: ReuseIdentifying>(reuseIdentifying: T.Type) {
    let nibName = UINib(nibName: T.reuseIdentifier, bundle: nil)
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
