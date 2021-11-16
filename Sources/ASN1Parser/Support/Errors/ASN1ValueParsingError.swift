//
//  ASN1ValueParsingError.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

/// Errors thrown during parsing of ASN.1 values
public enum ASN1ValueParsingError: Error {
  case invalidBoolean
  case invalidInteger
  case invalidNull
  case invalidObjectIdentifier
  case invalidBitString
  case invalidSequence
  case invalidSetElement
}
