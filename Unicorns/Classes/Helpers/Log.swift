//
//  Log.swift
//  Pods-Unicorns_Tests
//
//  Created by Bartek Żabicki on 27.03.2018.
//

import Foundation

final class Log {
  
  static let isLoggerEnabled = true
  
  static func e(_ message: String) {
    guard isLoggerEnabled else { return }
    print("❗️[Error]: \(message)")
  }
  
  static func i(_ message: String) {
    guard isLoggerEnabled else { return }
    print("❔[Debug]: \(message)")
  }
  
}
