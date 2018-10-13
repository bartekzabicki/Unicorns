//
//  ReuseIdentifying.swift
//  Pods-Unicorns_Tests
//
//  Created by Bartek Żabicki on 27.03.2018.
//
import UIKit

// MARK: - Protocols

///Protocol used to set reuseIdentifier property with name of view
public protocol ReuseIdentifying {
  static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
  
  public static var reuseIdentifier: String {
    return String(describing: Self.self)
  }
  
}

// MARK: - Extension

extension UICollectionViewCell: ReuseIdentifying {}

extension UITableViewCell: ReuseIdentifying {}

extension UIViewController: ReuseIdentifying {}
