//
//  Optional.swift
//  Extension
//
//  Created by Jarvis on 2022/12/20.
//

import Foundation

extension Optional {
  /// 可选值为空时返回true
  var isNone: Bool {
    switch self {
    case .none: return true
    case .some: return false
    }
  }
  
  /// 可选值非空返回true
  var isSome: Bool { return !isNone }
  
  /// 返回可选值或默认值
  /// - Parameter default: 可选值为空时返回
  func or(_ default: Wrapped) -> Wrapped {
    return self ?? `default`
  }
  
  /// 返回可选值或`else`表达式返回的值
  /// - Parameter else: 可选值为空时返回该表达式的值
  func or(else: @autoclosure () -> Wrapped) -> Wrapped {
    return self ?? `else`()
  }
  
  /// 返回可选值或`else`闭包返回的值
  /// - Parameter else: 闭包
  func or(else: () -> Wrapped) -> Wrapped {
    return self ?? `else`()
  }
  
  /// 可选值不为空时，返回可选值
  /// - Parameter exception: 可选值为空，抛出异常
  func or(throw exception: Error) throws -> Wrapped {
    guard let unwrapped = self else { throw exception }
    return unwrapped
  }
  
  /// 解包可选值，当可选值不为空时，执行 `then` 闭包，并返回执行结果
  /// - Parameter then: 可以将多个可选项连接在一起
  func and<T>(then: (Wrapped) throws -> T?) rethrows -> T? {
    guard let unwrapped = self else { return nil }
    return try then(unwrapped)
  }
  
  /// 可选值不为空且可选值满足 `predicate` 条件才返回，否则返回 `nil`
  /// - Parameter predicate: 可选值的条件满足判断
  func filter(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
    guard let unwarpped = self, predicate(unwarpped) else { return nil }
    return self
  }
  
  /// 可选值不为空时返回，否则Crash
  /// - Parameter message: Crash消息
  func expect(_ message: String) -> Wrapped {
    guard let value = self else { fatalError(message) }
    return value
  }
}

extension Optional where Wrapped == Error {
  func or(_ else: (Error) -> Void) {
    guard let error = self else { return }
    `else`(error)
  }
}
