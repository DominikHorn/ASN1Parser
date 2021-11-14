//
//  ASN1Null.swift
//  
//
//  Created by Dominik Horn on 11.11.21.
//

import Foundation

/// Each instance represents a single ASN.1 NULL value
public struct ASN1Null: ASN1Value {
  /// Construct an ASN.1 NULL value
  public init() {}
}

extension ASN1Null: Equatable {}

extension ASN1Null: CustomStringConvertible {
  public var description: String {
    "NULL"
  }
}
