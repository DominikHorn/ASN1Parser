//
//  ASN1Integer.swift
//  
//
//  Created by Dominik Horn on 11.11.21.
//

import Foundation
import BigInt

/// Represents an ASN.1 Integer value
public struct ASN1Integer: ASN1Value {
  public var value: BigInt
  
  /// Construct given a swift Int value
  public init (_ value: Int) {
    self.value = BigInt(value)
  }
  
  /// Construct given an arbitray length Integer
  public init(_ value: BigInt) {
    self.value = value
  }
}

extension ASN1Integer: Equatable {}

extension ASN1Integer: CustomStringConvertible {
  public var description: String {
    "INTEGER = \(value)"
  }
}
