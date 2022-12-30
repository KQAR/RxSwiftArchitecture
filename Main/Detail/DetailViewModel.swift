//
//  DetailViewModel.swift
//  VoltaEel
//
//  Created by Jarvis on 2022/12/30.
//

import Foundation
import Bindable

class DetailViewMode: ViewModel, ViewModelType {
  public struct Input {}
  public struct Output {}
  
  private let id: String
  
  init(_ id: String) {
    self.id = id
    super.init()
  }
  
  public func transform(input: Input) -> Output {
    return Output()
  }
}
