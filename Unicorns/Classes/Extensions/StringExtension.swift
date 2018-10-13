//
//  StringExtension.swift
//  CoCreate
//
//  Created by Bartek Żabicki on 27.02.2018.
//  Copyright © 2018 CoCreate. All rights reserved.
//

import Foundation

extension String {
  
  ///Localizing string value
  public var localized: String {
    return NSLocalizedString(self, comment: "")
  }
  
  ///Count of characters in text with joined emojis
  public var composedCharacterCount: Int {
    var count = 0
    enumerateSubstrings(in: startIndex..<endIndex, options: .byComposedCharacterSequences) { (_, _, _, _) in
      count += 1
    }
    return count
  }
  
}
