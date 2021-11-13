//
//  ASN1Integer.swift
//  
//
//  Created by Dominik Horn on 11.11.21.
//

import Foundation
import BigInt

/// https://docs.microsoft.com/en-us/windows/win32/seccertenroll/about-integer
public struct ASN1Integer: ASN1Value {
  var swiftValue: BigInt
  
  public init (_ swiftValue: Int) {
    self.swiftValue = BigInt(swiftValue)
  }
  
  public init(_ swiftValue: BigInt) {
    self.swiftValue = swiftValue
  }
}

extension ASN1Integer: ASN1LoadFromDER {
  init(der: Data) throws {
    guard let firstByte = der.first else {
      throw ASN1ParsingError.invalidInteger
    }
    
    var signed = firstByte.bit(at: 7)
    var dataView = der
    if der.count > 1 && firstByte == 0x00 {
      signed = false
      dataView = der[(der.startIndex+1)..<der.endIndex]
    }
    
    if signed {
      var bytes = [UInt8](dataView)
      bytes[0] &= (0x1 << 7) - 1
      
      swiftValue = BigInt(sign: .minus, magnitude: BigUInt(Data(bytes)))
    } else {
      swiftValue = BigInt(sign: .plus, magnitude: BigUInt(dataView))
    }
  }
}

extension ASN1Integer: Equatable {}
