//
//  ASN1Null.swift
//  
//
//  Created by Dominik Horn on 11.11.21.
//

import Foundation

/// https://docs.microsoft.com/en-us/windows/win32/seccertenroll/about-null
public struct ASN1Null: ASN1Value {
  public init() {}
}

extension ASN1Null: ASN1LoadFromDER {
  init(der: Data) throws {
    guard der.isEmpty else {
      throw ASN1ParsingError.invalidNull
    }
  }
}

extension ASN1Null: Equatable {}

extension ASN1Null: CustomStringConvertible {
  public var description: String {
    "NULL"
  }
}
