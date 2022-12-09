//
//  BindableType.swift
//  Bindable
//
//  Created by Jarvis on 2022/12/7.
//

import UIKit
import RxSwift

public protocol BindableType {
  associatedtype ViewModelType
  
  var viewModel: ViewModelType! { get set }
  
  func bindViewModel()
}

extension BindableType where Self: UIViewController {
  public mutating func bindViewModel(to model: Self.ViewModelType) {
    viewModel = model
    loadViewIfNeeded()
    bindViewModel()
  }
}
