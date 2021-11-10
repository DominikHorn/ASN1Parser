//
//  ASN1ParsingError.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

enum ASN1ParsingError: Error {
  case invalidTag
  case invalidLength
  case unimplemented(_ tag: ASN1TLV.Tag)
}
