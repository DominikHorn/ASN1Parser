//
//  ASN1DERParsingError.swift
//  
//
//  Created by Dominik Horn on 14.11.21.
//

import Foundation

/// Errors thrown during parsing of DER encoded ASN.1
public enum ASN1DERParsingError: Error {
  /// Unreadable TLV tag. Contains first tag byte
  case unreadableTag(UInt8)
  
  /// TLV length field contains a length value that does not fit into a swift Int
  case unsupportedTLVLength
  
  /// TLV length field specifies invalid lenght, e.g., more than available bytes
  case invalidTLVLength
}
