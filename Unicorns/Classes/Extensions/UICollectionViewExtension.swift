//
//  UICollectionViewExtension.swift
//  Pods-Unicorns_Example
//
//  Created by Bartek Żabicki on 13/10/2018.
//

import UIKit

extension UICollectionView {
  
  ///Register given cell with reuseIdentifier and nibName equal to cell's name
  public func register<T:ReuseIdentifying>(reuseIdentifying: T.Type) {
    let nibName = UINib(nibName: T.reuseIdentifier, bundle: nil)
    register(nibName, forCellWithReuseIdentifier: T.reuseIdentifier)
  }
  
  ///Dequaue reusable cell with identifier equal to cell's name
  public func dequeueReusable<T: ReuseIdentifying>(cell: T.Type, for indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
    }
    return cell
  }
  
}
