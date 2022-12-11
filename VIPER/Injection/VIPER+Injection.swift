//
//  VIPER+Injection.swift
//  VIPER
//
//  Created by Jarvis on 2022/12/7.
//

import Foundation
import Factory
import Mediator
import BaseView
import Bindable

public typealias ViewModelFactory = Factory<ViewModel>
public typealias ViewControllerFactory = Factory<ViewController>
public typealias ViewModelParameterFactory<P> = ParameterFactory<P, ViewModel>

public extension Container {
  
  static let tabItems = Factory { TabBarItems() }
  static let tabBar = Factory { TabBarController() }
  
  // MARK: - Injection View Model
  
  static let home = ViewModelFactory { HomeViewModel() }
  static let profile = ViewModelFactory { ProfileViewModel() }
  static let payment = ViewModelParameterFactory<(id: String, name: String)> { params in
    PaymentViewModel(params.id, name: params.name)
  }
  
  // MARK: - Injection View Controller
  
  static let homeViewController = ViewControllerFactory { HomeViewController() }
  static let profileViewController = ViewControllerFactory { ProfileViewController() }
  static let paymentViewController = ViewControllerFactory { PaymentViewController() }
  
  // MARK: - Injection Mediator
  
  static let mediator = Factory<MediatorProtocol> { MediatorTarget() }
}
