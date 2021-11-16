//
//  ASN1Null.swift
//  
//
//  Created by Dominik Horn on 11.11.21.
//

import Foundation

/// Represents an ASN.1 Null value
public struct ASN1Null: ASN1Value {
  public init() {}
}

extension ASN1Null: Equatable {}

extension ASN1Null: CustomStringConvertible {
  public var description: String {
    "NULL"
  }
}
