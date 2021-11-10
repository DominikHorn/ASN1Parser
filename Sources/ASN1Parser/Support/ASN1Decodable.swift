//
//  ASN1Decodable.swift
//  
//
//  Created by Dominik Horn on 10.11.21.
//

import Foundation

protocol ASN1Decodable {
  init(_ data: Data, offset: inout Data.Index) throws
}
