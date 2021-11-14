//
//  ASN1BitString.swift
//  
//
//  Created by Dominik Horn on 13.11.21.
//

import Foundation


/// https://docs.microsoft.com/en-us/windows/win32/seccertenroll/about-bit-string
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
      return bytes[realIndex / 8].bit(at: realIndex % 8)
    }
  }
}

extension ASN1BitString: ASN1LoadFromDER {
  init(der: Data) throws {
    let lastUnused = try Int(der.tryAccess(at: der.startIndex))
    guard lastUnused <= 8, der.startIndex + 1 < der.endIndex else {
      throw ASN1ParsingError.invalidBitString
    }
    
    let rawBytes = [UInt8](der[(der.startIndex+1)..<der.endIndex])
    
    // correctly shift in place on decode to avoid O(n) access cost
    self.bytes = (0..<rawBytes.count).map { (i: Int) in
        UInt8(rawBytes[i] >> lastUnused) | UInt8(i > 0 ? rawBytes[i-1] << (8 - lastUnused) : 0x00)
      }
    self.lastUnused = lastUnused
  }
}

extension ASN1BitString: Equatable {}

extension ASN1BitString: CustomStringConvertible {
  public var description: String {
    "BIT STRING = " + string
  }
}
