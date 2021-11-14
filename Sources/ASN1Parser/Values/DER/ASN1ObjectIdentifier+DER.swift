//
//  ASN1ObjectIdentifier+DER.swift
//  
//
//  Created by Dominik Horn on 14.11.21.
//

import Foundation
import BigInt

extension ASN1ObjectIdentifier: DERDecodable {
  /// https://docs.microsoft.com/en-us/windows/win32/seccertenroll/about-object-identifier
  init(der: Data) throws {
    let firstByte = try der.tryAccess(at: der.startIndex)
    
    // parse first byte
    nodes.append(BigUInt(firstByte / 40))
    nodes.append(BigUInt(firstByte % 40))
    
    // parse remaining bytes
    var baseOffset = der.startIndex + 1
    while baseOffset < der.endIndex {
      var lastByteOffset = baseOffset
      var lastByteSize = 1
      while try der.tryAccess(at: lastByteOffset).bit(at: 7) {
        lastByteOffset += 1
        lastByteSize += 1
      }
      
      var bytes = [UInt8](repeating: 0x00, count: lastByteSize)
      var lastAvailable = 0
      
      for (offset, i) in zip(baseOffset...lastByteOffset, 0..<lastByteSize).reversed() {
        let byte = try der.tryAccess(at: offset) & ((0x1 << 7) - 1)
        
        // store upper (7 - lastAvailable)
        bytes[i] = byte >> lastAvailable
        
        if lastAvailable > 0, i+1 < bytes.count {
          // extract lowest lastAvailable bits, shift into place and prepend
          let lowestK = byte & ((0x1 << lastAvailable) - 1)
          let lowestShifted = lowestK << (1 + 7 - lastAvailable)
          bytes[i+1] = lowestShifted | bytes[i+1]
        }
        lastAvailable = (lastAvailable + 1) % 8
      }
      
      nodes.append(BigUInt(Data(bytes)))
      baseOffset = lastByteOffset + 1
    }
    
    assert(baseOffset == der.endIndex)
  }
}
