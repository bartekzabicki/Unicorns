//
//  ReuseIdentifying.swift
//  Pods-Unicorns_Tests
//
//  Created by Bartek Żabicki on 27.03.2018.
//
import UIKit

// MARK: - Protocols

protocol ReuseIdentifying {
  static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
  
  static var reuseIdentifier: String {
    return String(describing: Self.self)
  }
  
}

// MARK: - Extension

extension UICollectionViewCell: ReuseIdentifying {}

extension UITableViewCell: ReuseIdentifying {}
