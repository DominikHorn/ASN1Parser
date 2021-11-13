//
//  ASN1ObjectIdentifier.swift
//  
//
//  Created by Dominik Horn on 11.11.21.
//

import Foundation
import BigInt

struct ASN1ObjectIdentifier: ASN1Value {
  var values = [BigUInt]()
  var id: String {
    values.map {
      "\($0)"
    }.joined(separator: ".")
  }
  
  public init(id: String) throws {
    values = try id.split(separator: ".").enumerated().map { (i, node) in
      guard let node = BigUInt(node), (i != 0 || node < 4), (i != 1 || node < 40) else {
        throw ASN1ConstructionError.invalidObjectIdentifierNode(index: i)
      }
      return node
    }
  }
  
  public init(nodes: [BigUInt]) throws {
    try nodes.enumerated().forEach { (i, node) in
      guard (i != 0 || node < 4), (i != 1 || node < 40) else {
        throw ASN1ConstructionError.invalidObjectIdentifierNode(index: i)
      }
    }
    self.values = nodes
  }
  
  init(data: Data) throws {
    let firstByte = try data.tryAccess(at: data.startIndex)
    
    // parse first byte
    values.append(BigUInt(firstByte / 40))
    values.append(BigUInt(firstByte % 40))
    
    // parse remaining bytes
    var baseOffset = data.startIndex + 1
    while baseOffset < data.endIndex {
      var lastByteOffset = baseOffset
      var lastByteSize = 1
      while try data.tryAccess(at: lastByteOffset).bit(at: 7) {
        lastByteOffset += 1
        lastByteSize += 1
      }
      
      var bytes = [UInt8](repeating: 0x00, count: lastByteSize)
      var lastAvailable = 0
      
      for (offset, i) in zip(baseOffset...lastByteOffset, 0..<lastByteSize).reversed() {
        let byte = try data.tryAccess(at: offset) & ((0x1 << 7) - 1)
        
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
      
      values.append(BigUInt(Data(bytes)))
      baseOffset = lastByteOffset + 1
    }
    
    guard baseOffset == data.endIndex else {
      throw ASN1ParsingError.invalidTLVLength
    }
    
    print(id)
  }
}

extension ASN1ObjectIdentifier: Equatable {}
