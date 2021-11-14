//
//  ASN1ConstructionError.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

/// Errors thrown during construction of ASN.1 values
public enum ASN1ConstructionError: Error {
  /// Thrown when sequence is constructed with no values
  case emptySequence
  
  /// Thrown when the object identifier's node at `index` is invalid
  case invalidObjectIdentifierNode(index: Int)
}
