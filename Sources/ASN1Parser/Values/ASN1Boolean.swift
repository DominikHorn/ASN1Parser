//
//  ASN1Boolean.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

/// https://docs.microsoft.com/en-us/windows/win32/seccertenroll/about-boolean
public struct ASN1Boolean: ASN1Value {
  var swiftValue: Bool
  
  public init(_ swiftValue: Bool) {
    self.swiftValue = swiftValue
  }
}

extension ASN1Boolean: ASN1LoadFromDER {
  init(der: Data) throws {
    guard der.count == 1 else {
      throw ASN1ParsingError.invalidTLVLength
    }
    
    let byte = try der.tryAccess(at: der.startIndex)
    guard byte == 0x00 || byte == 0x01 else {
      throw ASN1ParsingError.invalidBoolean
    }
    
    swiftValue = byte != 0
  }
}

extension ASN1Boolean: Equatable {}

extension ASN1Boolean: CustomStringConvertible {
  public var description: String {
    "BOOL = \(swiftValue)"
  }
}
