//
//  Log.swift
//  Pods-Unicorns_Tests
//
//  Created by Bartek Żabicki on 27.03.2018.
//

import Foundation

public final class Log {
  
  public static let isLoggerEnabled = true
  
  ///Function that logs string error
  public static func e(_ message: String) {
    guard isLoggerEnabled else { return }
    print("❗️[Error]: \(message)")
  }
  
  ///Function that logs error
  public static func e(_ error: Error) {
    guard isLoggerEnabled else { return }
    print("❗️[Error]: \(error.localizedDescription)")
  }
  
  ///Function that logs information
  public static func i(_ message: String) {
    guard isLoggerEnabled else { return }
    print("❔[Debug]: \(message)")
  }
  
  ///Function that logs success
  public static func s(_ message: String) {
    guard isLoggerEnabled else { return }
    print("🎉[Success]: \(message)")
  }
  
}
