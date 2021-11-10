//
//  File.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

protocol ASN1Value {
  init(_ data: Data, offset: inout Data.Index) throws
}
