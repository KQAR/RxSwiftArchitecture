//
//  Convenient.swift
//  Utility
//
//  Created by Jarvis on 2022/12/29.
//

public func Init<T>(_ type: T, modify: (T) -> Void) -> T {
  modify(type)
  return type
}
