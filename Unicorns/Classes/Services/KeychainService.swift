//
//  KeychainService.swift
//  Pods-Unicorns_Tests
//
//  Created by Bartek Żabicki on 04.04.2018.
//

import Foundation

public class KeychainService {
  
  public enum KeychainError: Error {
    case couldNotSave
    case noSuchValue
    case unexpectedValueData
    case unhandledError(status: OSStatus)
  }
  
  public struct Key : RawRepresentable, Equatable, Hashable {
    
    public var rawValue: String

    public init(_ rawValue: String) {
      self.rawValue = rawValue
    }
    
    public init(rawValue: String) {
      self.rawValue = rawValue
    }
    
  }
  
  // MARK: - Properties
  
  private let serviceName = "com.Unicorn.target"
  public static var shared = KeychainService()
  
  // MARK: - Initialization
  
  private init() {}
  
  // MARK: - Private functions
  
  public func save(value: String?, as key: Key) throws {
    guard let valueData = value?.data(using: .utf8) else {
      throw KeychainError.couldNotSave
    }
    let saveQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key.rawValue,
                                    kSecValueData as String: valueData]
    let status = SecItemAdd(saveQuery as CFDictionary, nil)
    guard status == errSecSuccess else {
      throw KeychainError.unhandledError(status: status)
    }
  }
  
  public func retrive(item key: Key) throws -> String {
    let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                kSecAttrAccount as String: key.rawValue,
                                kSecMatchLimit as String: kSecMatchLimitOne,
                                kSecReturnAttributes as String: true,
                                kSecReturnData as String: true]
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status != errSecItemNotFound else {
      throw KeychainError.noSuchValue
    }
    guard status == errSecSuccess else {
      throw KeychainError.unhandledError(status: status)
      
    }
    guard let existingItem = item as? [String: Any],
      let passwordData = existingItem[kSecValueData as String] as? Data,
      let password = String(data: passwordData, encoding: String.Encoding.utf8)
      else {
        throw KeychainError.unexpectedValueData
    }
    return password
  }
  
  public func delete(item key: Key) throws {
    let deleteQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                      kSecAttrAccount as String: key.rawValue]
    
    let status = SecItemDelete(deleteQuery as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw KeychainError.unhandledError(status: status)
    }
  }
  
}
