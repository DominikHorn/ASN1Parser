//
//  ASN1PrintableString.swift
//  
//
//  Created by Matthias Scheurer on 29.09.23.
//

import Foundation

/// Represents an ASN.1 UTF-8 String value
public struct ASN1PrintableString: ASN1Value {
  /// Decoded string value
  public var value: String
  
  /// Construct given a swift String value
  public init(_ value: String) {
    self.value = value
  }
}

extension ASN1PrintableString: Equatable {}

extension ASN1PrintableString: CustomStringConvertible {
  public var description: String {
    "PRINTABLE STRING = \(value)"
  }
}
