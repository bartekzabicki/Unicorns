//
//  KeyedDecodingContainerExtension.swift
//  Unicorns
//
//  Created by Bartek Żabicki on 29/09/2018.
//

import Foundation

extension KeyedDecodingContainer {
  
  ///Convenience function that decode given key of type
  public func decodeIfPresent<T>(key: K, defaultValue: T) throws -> T where T : Decodable {
      return try decodeIfPresent(T.self, forKey: key) ?? defaultValue
  }
  
}
