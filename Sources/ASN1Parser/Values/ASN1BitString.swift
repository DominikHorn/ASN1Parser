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
        .dropLast(lastUnused)
    )
  }
  
  public var value: Data {
    var out = [UInt8](repeating: 0x00, count: bytes.count)
    
    (0..<bytes.count).forEach { i in
      out[i] = (bytes[i] >> lastUnused) | (i > 0 ? bytes[i-1] << (8 - lastUnused) : 0x00)
    }
    
    return Data(out)
  }
  
  public subscript(index: Int) -> Bool {
    get {
      bytes[index / 8].bit(at: index % 8)
    }
  }
}

extension ASN1BitString: ASN1LoadFromDER {
  init(der: Data) throws {
    self.lastUnused = try Int(der.tryAccess(at: der.startIndex))
    guard lastUnused <= 8, der.startIndex + 1 < der.endIndex else {
      throw ASN1ParsingError.invalidBitString
    }
    self.bytes = .init(der[(der.startIndex+1)..<der.endIndex])
  }
}

extension ASN1BitString: Equatable {}

extension ASN1BitString: CustomStringConvertible {
  public var description: String {
    "BIT STRING = " + string
  }
}
