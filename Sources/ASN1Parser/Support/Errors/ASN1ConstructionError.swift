//
//  ASN1ConstructionError.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

public enum ASN1ConstructionError: Error {
  case emptySequence
  case invalidObjectIdentifierNode(index: Int)
}
