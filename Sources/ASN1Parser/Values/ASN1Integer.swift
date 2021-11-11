//
//  ASN1Integer.swift
//  
//
//  Created by Dominik Horn on 11.11.21.
//

import Foundation
import BigInt

struct ASN1Integer: ASN1Value {
  var swiftValue: BigInt
  
  init(_ swiftValue: BigInt) {
    self.swiftValue = swiftValue
  }
  
  init(data: Data) throws {
    guard let firstByte = data.first else {
      throw ASN1ParsingError.invalidInteger
    }
    
    var signed = firstByte.bit(at: 7)
    var dataView = data
    if data.count > 1 && firstByte == 0x00 {
      signed = false
      dataView = data[(data.startIndex+1)..<data.endIndex]
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
