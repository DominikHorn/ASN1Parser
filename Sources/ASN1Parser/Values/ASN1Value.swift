//
//  ASN1Value.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

/**
 Generic ASN.1 value container, i.e., each ASN.1 Value conforms to this protocol
 
 Use the provided methods and accessors to traverse the ASN.1 value tree
 */
public protocol ASN1Value {
  func isEqualTo(_ other: ASN1Value) -> Bool
}

public extension ASN1Value where Self: Equatable {
  func isEqualTo(_ other: ASN1Value) -> Bool {
    guard let other = other as? Self else { return false }
    return self == other
  }
}
