//
//  ASN1BitString.swift
//  
//
//  Created by Dominik Horn on 13.11.21.
//

import Foundation

/// Each instance represents a single ASN.1 Bit String value
public struct ASN1BitString: ASN1Value {
  /**
   Raw bytes of the Bit String, encoded in little endian.
   
   The first byte may contain up to 7 leading padding zeroes.
   To find out how many of the topmost bits are unused in the
   first byte, you may utilize
   ``ASN1BitString/paddingLength``.
   */
  public var bytes: [UInt8]
  
  /// Amount of leading padding bits in ``ASN1BitString/bytes``
  public var paddingLength: Int
  
  /// Total amount of bits in this Bit String
  public var count: Int {
    bytes.count * 8 - paddingLength
  }
  
  /// Binary encoded string representation
  public var string: String {
    String(
      bytes
        .map { String($0, radix: 2).leftPadding(toLength: 8, withPad: "0") }
        .joined(separator: "")
        .dropFirst(paddingLength)
    )
  }
  
  /**
   Construct given
   - Parameters:
    - value: bytes of the bitstring in little endian order, i.e., least significant byte first. Any
        padding bytes should be prepended, i.e., padding bits begin in the leading bit of the first byte.
    - paddingLength: Length of padding.
   */
  public init(value: [UInt8], paddingLength: Int) {
    self.bytes = .init(value.dropFirst(paddingLength / 8))
    self.paddingLength = paddingLength % 8
  }
  
  /**
   Accesses a single bit at the given index.
   
   - Parameter index: Index into the Bit String, starting at 0 for the first value bit.
   */
  public subscript(index: Int) -> Bool {
    get {
      // take unused bits into account
      let realIndex = index + paddingLength
      return bytes[realIndex / 8].bit(at: 7 - (realIndex % 8))
    }
  }
}

extension ASN1BitString: Equatable {}

extension ASN1BitString: CustomStringConvertible {
  public var description: String {
    "BIT STRING = " + string
  }
}
