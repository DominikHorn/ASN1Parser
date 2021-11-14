//
//  ASN1ObjectIdentifier.swift
//  
//
//  Created by Dominik Horn on 11.11.21.
//

import Foundation
import BigInt

public struct ASN1ObjectIdentifier: ASN1Value {
  var values = [BigUInt]()
  public var id: String {
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
}

extension ASN1ObjectIdentifier: Equatable {}

extension ASN1ObjectIdentifier: CustomStringConvertible {
  public var description: String {
    "OBJECT IDENTIFIER = \(id)"
  }
}
