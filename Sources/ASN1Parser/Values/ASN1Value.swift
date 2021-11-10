//
//  ASN1Value.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

public protocol ASN1Value {
  init(data: Data) throws
  
  func isEqualTo(_ other: ASN1Value) -> Bool
}

extension ASN1Value where Self: Equatable {
  func isEqualTo(_ other: ASN1Value) -> Bool {
    guard let other = other as? Self else { return false }
    return self == other
  }
}
