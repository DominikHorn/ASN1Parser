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
  var swiftValue: BigInt
  
  /// Construct given a swift Int value
  public init (_ swiftValue: Int) {
    self.swiftValue = BigInt(swiftValue)
  }
  
  /// Construct given an arbitray length Integer
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
