//
//  UISegmentControlExtension.swift
//  Unicorns
//
//  Created by Bartek Żabicki on 27/09/2018.
//

import UIKit

extension UISegmentedControl {
  
  public typealias localizedTitle = (title: String, index: Int)
  
  /**
   Function that localize UISegmentControl's titles
   - Parameter titles: The array of touples with titles and indexes
 */
  public func localize(with titles: [localizedTitle]) {
    titles.forEach { touple in
      if touple.index < numberOfSegments {
        setTitle(touple.title, forSegmentAt: touple.index)
      }
    }
  }
  
}
