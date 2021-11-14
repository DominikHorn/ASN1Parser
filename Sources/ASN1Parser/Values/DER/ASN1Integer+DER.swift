//
//  ASN1Integer+DER.swift
//  
//
//  Created by Dominik Horn on 14.11.21.
//

import Foundation
import BigInt

extension ASN1Integer: DERDecodable {
  /// https://docs.microsoft.com/en-us/windows/win32/seccertenroll/about-integer
  init(der: Data) throws {
    guard let firstByte = der.first else {
      throw ASN1ValueParsingError.invalidInteger
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
