//
//  Validation.swift
//  CompanyManager
//
//  Created by Bartek Żabicki on 02.03.2019.
//  Copyright © 2018 bartekzabicki. All rights reserved.
//

import Foundation

typealias ValidationStatus = Validation.ValidationStatus
typealias ValitationField = Validation.Field
typealias ValidationStructure = Validation.ValidationStructure

class Validation {
  
  struct ValidationStructure {
    var minChars: Int
    var maxChars: Int
    var regexp: String?
    var regexpError: String?
  }
  
  struct Configuration {
    var obligatoryFields: [Field]
    var optionalFields: [Field] = []
    private var fields: [Field] {
      return obligatoryFields + optionalFields
    }
    internal var fieldsValidationStatus: [Field: Bool] = [:]
    
    init(obligatoryFields: [Field], optionalFields: [Field] = []) {
      self.obligatoryFields = obligatoryFields
      self.optionalFields = optionalFields
      fields.forEach({ fieldsValidationStatus[$0] = false })
      optionalFields.forEach({ fieldsValidationStatus[$0] = false })
    }
    
    func isValid() -> Bool {
      fieldsValidationStatus.forEach { row in
        print(row)
      }
      return fieldsValidationStatus.first(where: { !$0.value })?.value ?? true
    }
  }
  
  public struct Field: RawRepresentable, Equatable, Hashable {
    
    public let rawValue: String
    public let requirements: ValidationStructure?
    
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
  
  enum ValidationStatus {
    case validated
    case notValidated(Validation.Error)
  }
  
  enum Error: LocalizedError {
    case empty(fieldType: Field)
    case toFewCharacters(fieldType: Field)
    case toManyCharacters(fieldType: Field)
    case regexError(fieldType: Field)
    case custom(String, fieldType: Field)
    
    var fieldType: Field {
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
    
    var errorDescription: String? {
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
  
  private var _configuration: Configuration
  var configuration: Configuration {
    return _configuration
  }
  
  // MARK: - Initialization
  
  init(configuration: Configuration) {
    self._configuration = configuration
  }
  
  // MARK: - Functions
  
  func validate(text: String?, as fieldType: Field) throws {
    _configuration.fieldsValidationStatus[fieldType] = false
    guard let text = text else {
      guard configuration.optionalFields.contains(fieldType) else {
        throw Error.empty(fieldType: fieldType)
      }
      _configuration.fieldsValidationStatus[fieldType] = nil
      return
    }
    
    if text.isEmpty, configuration.optionalFields.contains(fieldType) {
      _configuration.fieldsValidationStatus[fieldType] = nil
      return
    }
    
    guard let requirements = fieldType.requirements else {
      _configuration.fieldsValidationStatus[fieldType] = !text.isEmpty
      
      guard text.isEmpty else { return }
      throw Error.empty(fieldType: fieldType)
      
    }
    
    if text.count < requirements.minChars {
      throw Error.toFewCharacters(fieldType: fieldType)
    } else if text.count > requirements.maxChars {
      throw Error.toManyCharacters(fieldType: fieldType)
    }
    
    let predicate = NSPredicate(format: "SELF MATCHES %@", requirements.regexp ?? "")
    let isValidated = predicate.evaluate(with: text)
    _configuration.fieldsValidationStatus[fieldType] = isValidated
    
    guard !isValidated else { return }
    throw Error.regexError(fieldType: fieldType)
  }
  
  func `is`(text: String?, ofType fieldType: Field) -> Bool {
    guard let text = text else { return false }
    guard let requirements = fieldType.requirements else {
      return true
    }
    if text.count < requirements.minChars || text.count > requirements.maxChars {
      return false
    }
    return NSPredicate(format: "SELF MATCHES %@", requirements.regexp ?? "").evaluate(with: text)
  }
  
}
