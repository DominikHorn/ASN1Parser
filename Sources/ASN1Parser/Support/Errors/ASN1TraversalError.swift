//
//  ASN1TraversalError.swift
//  
//
//  Created by Dominik Horn on 14.11.21.
//

import Foundation

/// Errors thrown during ASN.1 traversal
enum ASN1TraversalError: Error {
  /// Thrown upon an illegal cast, for example when the expected ASN.1 value type
  /// does not match the received type. Contains the actually received value
  case invalidCast(ASN1Value)
  
  /// Thrown upon an index out of bounds access, e.g., into a sequence
  case outOfBounds
}
