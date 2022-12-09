//
//  Debug.swift
//  Log
//
//  Created by Jarvis on 2022/12/7.
//

import Foundation

public struct DebugType: RawRepresentable {
  public static let network = DebugType(rawValue: "🕷️")
  public static let debug = DebugType(rawValue: "🐞")
  public static let boat = DebugType(rawValue: "🚢")
  public static let page = DebugType(rawValue: "⛩️")
  
  public static let none = DebugType(rawValue: "")
  public var rawValue: String
  public init(rawValue: String) {
    self.rawValue = rawValue
  }
}

public func printLog<T>(_ message: T,
                             type: DebugType = .none,
                             file: String = #file,
                           method: String = #function,
                             line: Int = #line) {
  #if DEBUG
  print("\(type.rawValue)\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
  #endif
}
