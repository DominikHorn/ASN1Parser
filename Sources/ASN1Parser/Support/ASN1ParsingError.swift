//
//  ASN1ParsingError.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

enum ASN1ParsingError: Error {
  case unreadableTag
  case derViolation
  
  case invalidTLVLength
  case invalidSequence
  
  // TODO(anyone): eliminate once this is no longer valid
  case unimplementedValue
}
