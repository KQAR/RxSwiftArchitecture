//
//  IdentifiableViewModel.swift
//  Bindable
//
//  Created by Jarvis on 2022/12/7.
//

import Foundation
import RxDataSources

open class IdentifiableViewModel: Equatable, IdentifiableType {
  public let identity = UUID()
  
  public init() {}
  public static func == (lhs: IdentifiableViewModel, rhs: IdentifiableViewModel) -> Bool {
    return lhs.identity == rhs.identity
  }
}
