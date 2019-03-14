//
//  Validation.swift
//  CompanyManager
//
//  Created by Bartek Żabicki on 02.03.2019.
//  Copyright © 2018 bartekzabicki. All rights reserved.
//

import Foundation

public typealias ValidationStatus = Validation.ValidationStatus
public typealias ValitationField = Validation.Field
public typealias ValidationStructure = Validation.ValidationStructure

public final class Validation {
  
  public struct ValidationStructure {
    var minChars: Int
    var maxChars: Int
    var regexp: String?
    var regexpError: String?
    
    public init(minChars: Int, maxChars: Int, regexp: String?, regexpError: String?) {
      self.minChars = minChars
      self.maxChars = maxChars
      self.regexp = regexp
      self.regexpError = regexpError
    }
  }
  
  public struct Configuration {
    var obligatoryFields: [Field]
    var optionalFields: [Field] = []
    private var fields: [Field] {
      return obligatoryFields + optionalFields
    }
    fileprivate(set) public var fieldsValidationStatus: [Field: ValidationStatus] = [:]
    
    public init(obligatoryFields: [Field], optionalFields: [Field] = []) {
      self.obligatoryFields = obligatoryFields
      self.optionalFields = optionalFields
      fields.forEach({ fieldsValidationStatus[$0] = .notValidated(.empty(fieldType: $0)) })
      optionalFields.forEach({ fieldsValidationStatus[$0] = .notValidated(.empty(fieldType: $0)) })
    }
    
    public func isValid() -> Bool {
      return fieldsValidationStatus.contains(where: { touple -> Bool in
        switch touple.value {
        case .validated:
          return false
        case .notValidated:
          return true
        }
      })
    }
    
    fileprivate mutating func clear() {
      fieldsValidationStatus.removeAll()
    }
  }
  
  public struct Field: RawRepresentable, Equatable, Hashable {
    
    public let rawValue: String
    public let requirements: ValidationStructure?
    public func hash(into hasher: inout Hasher) {
      
    }
    
    public init(_ rawValue: String, requirements: ValidationStructure) {
      self.rawValue = rawValue
      self.requirements = requirements
    }
    
    public init(rawValue: String) {
      self.rawValue = rawValue
      self.requirements = nil
    }
    
  }
  
  // MARK: - Enums
  
  public enum ValidationStatus {
    case validated
    case notValidated(Validation.Error)
  }
  
  public enum Error: LocalizedError {
    case empty(fieldType: Field)
    case toFewCharacters(fieldType: Field)
    case toManyCharacters(fieldType: Field)
    case regexError(fieldType: Field)
    case custom(String, fieldType: Field)
    
    public var fieldType: Field {
      switch self {
      case .empty(let fieldType),
           .toFewCharacters(let fieldType),
           .toManyCharacters(let fieldType),
           .regexError(let fieldType):
        return fieldType
      case .custom(_, fieldType: let fieldType):
        return fieldType
      }
    }
    
    public var errorDescription: String? {
      switch self {
      case .empty:
        return "\("Validation.PleaseProvide")".localizedWith(fieldType.rawValue)
      case .toFewCharacters(fieldType: let fieldType):
        return "\("Validation.MinCharsRequired")".localizedWith(fieldType.requirements?.minChars ?? 0)
      case .toManyCharacters(fieldType: let fieldType):
        return "\("Validation.MaxCharsReached")".localizedWith(fieldType.requirements?.maxChars ?? 0)
      case .regexError(fieldType: let fieldType):
        return fieldType.requirements?.regexpError ?? ""
      case .custom(let message, fieldType: _):
        return message
      }
    }
    
  }
  
  // MARK: - Properties
  
  private(set) public var configuration: Configuration
  
  // MARK: - Initialization
  
  public init(configuration: Configuration) {
    self.configuration = configuration
  }
  
  // MARK: - Functions
  
  public func validate(text: String?, as fieldType: Field) throws {
    configuration.fieldsValidationStatus[fieldType] = .notValidated(.empty(fieldType: fieldType))
    guard let text = text else {
      guard configuration.optionalFields.contains(fieldType) else {
        let validationError = Error.empty(fieldType: fieldType)
        configuration.fieldsValidationStatus[fieldType] = .notValidated(validationError)
        throw validationError
      }
      configuration.fieldsValidationStatus[fieldType] = nil
      return
    }
    
    if text.isEmpty, configuration.optionalFields.contains(fieldType) {
      configuration.fieldsValidationStatus[fieldType] = nil
      return
    }
    
    guard let requirements = fieldType.requirements else {
      configuration.fieldsValidationStatus[fieldType] = .validated
      
      guard text.isEmpty else { return }
      let validationError = Error.empty(fieldType: fieldType)
      configuration.fieldsValidationStatus[fieldType] = .notValidated(validationError)
      throw validationError
      
    }
    
    if text.count < requirements.minChars {
      throw Error.toFewCharacters(fieldType: fieldType)
    } else if text.count > requirements.maxChars {
      throw Error.toManyCharacters(fieldType: fieldType)
    }
    
    let predicate = NSPredicate(format: "SELF MATCHES %@", requirements.regexp ?? "")
    let isValidated = predicate.evaluate(with: text)
    configuration.fieldsValidationStatus[fieldType] = .validated
    
    guard !isValidated else { return }
    let validationError = Error.regexError(fieldType: fieldType)
    configuration.fieldsValidationStatus[fieldType] = .notValidated(validationError)
    throw validationError
  }
  
  public func `is`(text: String?, ofType fieldType: Field) -> Bool {
    guard let text = text else { return false }
    guard let requirements = fieldType.requirements else {
      return true
    }
    if text.count < requirements.minChars || text.count > requirements.maxChars {
      return false
    }
    return NSPredicate(format: "SELF MATCHES %@", requirements.regexp ?? "").evaluate(with: text)
  }
  
  public func clearConfiguration() {
    configuration.clear()
  }
  
}
