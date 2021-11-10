//
//  ASN1TLV+Length.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

/// As documented in https://docs.microsoft.com/en-us/windows/win32/seccertenroll/about-encoded-length-and-value-bytes
extension ASN1TLV {
  struct Length: ASN1Value {
    let value: Int
    
    init(_ data: Data, offset: inout Data.Index) throws {
      let firstByte = data[offset]
      offset += 1
      
      if firstByte.bit(at: 7) {
        value = Int(firstByte & ((0x1 << 7) - 1))
      } else {
        value = Int(firstByte)
      }
    }
  }
}
