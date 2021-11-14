//
//  ASN1Integer.swift
//  
//
//  Created by Dominik Horn on 11.11.21.
//

import Foundation
import BigInt

/// Each instance represents a single ASN.1 INTEGER value
public struct ASN1Integer: ASN1Value {
  var swiftValue: BigInt
  
  /// Construct an ASN.1 INTEGER from a swift Int value
  public init (_ swiftValue: Int) {
    self.swiftValue = BigInt(swiftValue)
  }
  
  /// Construct an ASN.1 INTEGER from a BigInt, i.e., arbitray length Integer
  public init(_ swiftValue: BigInt) {
    self.swiftValue = swiftValue
  }
}

extension ASN1Integer: Equatable {}

extension ASN1Integer: CustomStringConvertible {
  public var description: String {
    "INTEGER = \(swiftValue)"
  }
}
