//
//  ASN1ParsingError.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

enum ASN1ParsingError: Error {
  case unreadableTag
  case unsupportedTLVLength
  case invalidTLVLength
  
  case invalidBoolean
  case invalidInteger
  case invalidNull
  case invalidSequence
  
  case illegalInstantiation
  
  // TODO(anyone): eliminate once this is no longer valid
  case unimplementedValue
}
