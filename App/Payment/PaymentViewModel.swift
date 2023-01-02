//
//  PaymentViewModel.swift
//  VIPER
//
//  Created by Jarvis on 2022/12/7.
//

import Foundation
import Bindable

public class PaymentViewModel: ViewModel, ViewModelType {
  
  public struct Input {}
  public struct Output {}
  
  private let id: String
  private let name: String
  
  init(_ id: String, name: String) {
    self.id = id
    self.name = name
    super.init()
  }
  
  public func transform(input: Input) -> Output {
    return Output()
  }
  
}

