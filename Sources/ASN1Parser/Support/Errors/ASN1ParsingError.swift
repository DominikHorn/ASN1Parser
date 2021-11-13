//
//  ASN1ParsingError.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

enum ASN1ParsingError: Error {
  case unreadableTag(UInt8)
  case unsupportedTLVLength
  case invalidTLVLength
  
  case invalidBoolean
  case invalidInteger
  case invalidNull
  case invalidObjectIdentifier
  case invalidSequence
  
  case illegalInstantiation
  
  case unimplemented(tag: ASN1Parser.Tag, length: ASN1Parser.Length, value: Data)
}
