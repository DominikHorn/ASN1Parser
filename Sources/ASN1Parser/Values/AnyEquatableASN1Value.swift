//
//  AnyEquatableASN1Value.swift
//  
//
//  Created by Dominik Horn on 11.11.21.
//

import Foundation

struct AnyEquatableASN1Value: ASN1Value {
  init(data: Data) throws {
    throw ASN1ParsingError.illegalInstantiation
  }
  
  private let value: ASN1Value
}

extension AnyEquatableASN1Value: Equatable {
  static func ==(lhs: AnyEquatableASN1Value, rhs: AnyEquatableASN1Value) -> Bool {
    return lhs.value.isEqualTo(rhs.value)
  }
}
