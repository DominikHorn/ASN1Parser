//
//  ASN1Value+convenientAccess.swift
//  
//
//  Created by Dominik Horn on 14.11.21.
//

import Foundation

public extension ASN1Value {
  fileprivate func cast<To: ASN1Value>(_ val: ASN1Value) throws -> To {
    guard let casted = self as? To else {
      throw ASN1TraversalError.invalidCast(self)
    }
    return casted
  }
  
  /// Try casting to ``ASN1Null`` Throws if cast fails
  var asNull: ASN1Null {
    get throws { try cast(self) }
  }
  
  /// Try casting to ``ASN1Bool`` Throws if cast fails
  var asBool: ASN1Boolean {
    get throws { try cast(self) }
  }
  
  /// Try casting to ``ASN1Integer`` Throws if cast fails
  var asInt: ASN1Integer {
    get throws { try cast(self) }
  }
  
  /// Try casting to ``ASN1ObjectIdentifier`` Throws if cast fails
  var asObjectIdentifier: ASN1ObjectIdentifier {
    get throws { try cast(self) }
  }
  
  /// Try casting to ``ASN1BitString`` Throws if cast fails
  var asBitString: ASN1BitString {
    get throws { try cast(self) }
  }
  
  /// Try casting to ``ASN1OctetString`` Throws if cast fails
  var asOctetString: ASN1OctetString {
    get throws { try cast(self) }
  }
  
  /// Try casting to ``ASN1UTF8String`` Throws if cast fails
  var asUTF8String: ASN1UTF8String {
    get throws { try cast(self) }
  }
  
  /// Try casting to ``ASN1Sequence`` Throws if cast fails
  var asSequence: ASN1Sequence {
    get throws { try cast(self) }
  }
  
  /// Try casting to ``ASN1Set`` Throws if cast fails
  var asSet: ASN1Set {
    get throws { try cast(self) }
  }
}
