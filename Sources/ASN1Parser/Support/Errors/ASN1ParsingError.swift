//
//  ASN1ParsingError.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

public enum ASN1ParsingError: Error {
  case unreadableTag(UInt8)
  case unsupportedTLVLength
  case invalidTLVLength
  
  case invalidBoolean
  case invalidInteger
  case invalidNull
  case invalidObjectIdentifier
  case invalidBitString
  case invalidSequence
  
  case illegalInstantiation
}
