//
//  ASN1UTF8String.swift
//  
//
//  Created by Dominik Horn on 16.11.21.
//

import Foundation

/// Represents an ASN.1 UTF-8 String value
public struct ASN1UTF8String: ASN1Value {
  /// Decoded string value
  public var value: String
  
  /// Construct given a swift String value
  public init(_ value: String) {
    self.value = value
  }
}

extension ASN1UTF8String: Equatable {}

extension ASN1UTF8String: CustomStringConvertible {
  public var description: String {
    "UTF8 STRING = \(value)"
  }
}
