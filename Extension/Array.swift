//
//  Array.swift
//  Extension
//
//  Created by Jarvis on 2023/3/24.
//

import Foundation

public extension Collection {
  /// Returns the element at the specified index iff it is within bounds, otherwise nil.
  subscript(safe index: Index) -> Element? {
    if indices.contains(index) {
      return self[index]
    } else {
      return nil
    }
  }
}

public extension Array {
  @discardableResult
  mutating func safeRemove(at index: Index) -> Bool {
    if indices.contains(index) {
      remove(at: index)
      return true
    } else {
      return false
    }
  }
}
