//
//  Debug.swift
//  Log
//
//  Created by Jarvis on 2022/12/7.
//

import Foundation

public struct DebugTag: RawRepresentable {
  public static let arrow = DebugTag(rawValue: "👉")
  
  public static let network = DebugTag(rawValue: "<🌐>")
  public static let debug = DebugTag(rawValue: "<🐞>")
  public static let boat = DebugTag(rawValue: "<🚢>")
  public static let page = DebugTag(rawValue: "<⛩️>")
  
  public static let success = DebugTag(rawValue: "<✅>")
  public static let failure = DebugTag(rawValue: "<❌>")
  
  public static let none = DebugTag(rawValue: "")
  public var rawValue: String
  public init(rawValue: String) {
    self.rawValue = rawValue
  }
}

public func printLog<T>(_ message: T,
                             file: String = #file,
                           method: String = #function,
                        line: Int = #line) {
  printLog(message, tags: .arrow, file: file, method: method, line: line)
}
public func printLog<T>(_ message: T,
                             tags: DebugTag...,
                             file: String = #file,
                           method: String = #function,
                             line: Int = #line) {
  #if DEBUG
  print("\(tags.map(\.rawValue).joined(separator: "&&"))\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)\n")
  #endif
}
