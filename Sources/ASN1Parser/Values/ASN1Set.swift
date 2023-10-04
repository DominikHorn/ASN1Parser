//
//  ASN1Set.swift
//  
//
//  Created by Dominik Horn on 16.11.21.
//

import Foundation

/// Represents an ASN.1 Set value
public struct ASN1Set: ASN1Value {
  /// ASN.1 values contained in this set in any order
  internal var first: ASN1Value
  internal var remaining = [ASN1Value]()

  /**
   Construct given static values with a no throws guarantee

   Since this is a set, there is no formal guarantee that order will be preserved
   
   - Parameters:
    - first: first element inserted into the set
    - next: zero or more values, inserted one after another
   */
  public init(_ any: ASN1Value, _ next: ASN1Value...) {
    self.first = any
    self.remaining = next
  }
  
  /**
   Construct given a list of values. Must not be empty.
   
   Since this is a set, there is no formal guarantee that order will be preserved
   
   - Parameters:
    - values: values of the set in any order
   
   - Throws ``ASN1ConstructionError/emptySequence`` if `values` is empty
   */
  public init(_ values: [ASN1Value]) throws {
    guard !values.isEmpty, let first = values.first else {
      throw ASN1ConstructionError.emptySequence
    }
    self.first = first
    self.remaining = .init(values.dropFirst())
  }
  
  /// Amount of ASN.1 values in this sequence
  public var count: Int {
    1 + remaining.count
  }
  
  /// Returns any element in the set
  public var any: ASN1Value {
    first
  }
  
  /// Returns all values of the set in any order
  public var values: [ASN1Value] {
    [first] + remaining
  }
}

extension ASN1Set: Equatable {
  /// Two ASN.1 Sequences are equal if all their values (in order) are equal to one another
  public static func == (lhs: ASN1Set, rhs: ASN1Set) -> Bool {
    guard lhs.count == rhs.count else { return false }
    
    // check must be more complicated since order is technically irrelevant
    var otherVals = rhs.values
    return lhs.values.allSatisfy { val in
      guard let ind = otherVals.firstIndex(where: { val.isEqualTo($0) }) else { return false }
      otherVals.remove(at: ind)
      return true
    }
  }
}

extension ASN1Set: CustomStringConvertible {
  public var description: String {
    "SET:\n" + values.map { "\t\($0)".replacingOccurrences(of: "\n", with: "\n\t") }.joined(separator: "\n")
  }
}
