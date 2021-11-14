//
//  ASN1BitString.swift
//  
//
//  Created by Dominik Horn on 13.11.21.
//

import Foundation


public struct ASN1BitString: ASN1Value {
  var bytes: [UInt8]
  var lastUnused: Int
  
  public var count: Int {
    bytes.count * 8 - lastUnused
  }
  
  public var string: String {
    String(
      bytes
        .map { String($0, radix: 2).leftPadding(toLength: 8, withPad: "0") }
        .joined(separator: "")
        .dropFirst(lastUnused)
    )
  }
  
  public var value: Data {
    Data(bytes)
  }
  
  public subscript(index: Int) -> Bool {
    get {
      // take unused bits into account
      let realIndex = index + lastUnused
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
