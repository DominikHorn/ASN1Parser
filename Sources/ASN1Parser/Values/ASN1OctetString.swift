//
//  ASN1OctetString.swift
//  
//
//  Created by Dominik Horn on 16.11.21.
//

import Foundation

/// Represents an ASN.1 Octet String value
public struct ASN1OctetString: ASN1Value {
  /// Raw bytes of the Octet String, encoded in little endian.
  public var bytes: [UInt8]
  
  /// Total amount of bytes in this Octet String
  public var count: Int {
    bytes.count
  }
  
  /// Base16 encoded string representation
  public var hex: String {
    String(
      bytes
        .map { String($0, radix: 16).leftPadding(toLength: 2, withPad: "0") }
        .joined(separator: " ")
    )
  }
  
  public init(_ bytes: [UInt8]) {
    self.bytes = bytes
  }
}

extension ASN1OctetString: Equatable {}

extension ASN1OctetString: CustomStringConvertible {
  public var description: String {
    "OCTET STRING = " + hex
  }
}
