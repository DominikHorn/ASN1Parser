//
//  ASN1Integer.swift
//  
//
//  Created by Dominik Horn on 11.11.21.
//

import Foundation
import BigInt

public struct ASN1Integer: ASN1Value {
  var swiftValue: BigInt
  
  public init (_ swiftValue: Int) {
    self.swiftValue = BigInt(swiftValue)
  }
  
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
