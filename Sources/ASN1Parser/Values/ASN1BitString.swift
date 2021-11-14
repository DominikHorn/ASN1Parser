//
//  ASN1BitString.swift
//  
//
//  Created by Dominik Horn on 13.11.21.
//

import Foundation

/**
 Each instance represents a single ASN.1 BIT STRING value.
 */
public struct ASN1BitString: ASN1Value {
  /**
   Raw value of the BIT STRING.
   
   Bytes are encoded in little endian, with the first byte
   containing up to 7 leading padding zeroes. To find out
   how many of the topmost bits are unused, you may utilize
   ``ASN1BitString/paddingLength``.
   */
  public var bytes: [UInt8]
  
  /// Amount of leading padding bits in the BIT STRING
  public var paddingLength: Int
  
  /// Amount of bits in this BIT STRING
  public var count: Int {
    bytes.count * 8 - paddingLength
  }
  
  /// Binary encoded string representation of the BIT STRING
  public var string: String {
    String(
      bytes
        .map { String($0, radix: 2).leftPadding(toLength: 8, withPad: "0") }
        .joined(separator: "")
        .dropFirst(paddingLength)
    )
  }

  /**
   Accesses a single bit at the given index, taking padding into account
   
   Index 0 corresponds to the first bit of the BIT STRING, i.e., padding
   is ignored.
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
