//
//  Log.swift
//  Pods-Unicorns_Tests
//
//  Created by Bartek Żabicki on 27.03.2018.
//

import Foundation

public final class Log {
  
  public static let isLoggerEnabled = true
  
  public static func e(_ message: String) {
    guard isLoggerEnabled else { return }
    print("❗️[Error]: \(message)")
  }
  
  public static func e(_ error: Error) {
    guard isLoggerEnabled else { return }
    print("❗️[Error]: \(error.localizedDescription)")
  }
  
  public static func i(_ message: String) {
    guard isLoggerEnabled else { return }
    print("❔[Debug]: \(message)")
  }
  
}
