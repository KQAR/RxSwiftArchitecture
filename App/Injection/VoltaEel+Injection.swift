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
import ReactorKit

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
  static let detail = ViewModelParameterFactory<String> { params in
    DetailViewModel(params)
  }
  
  // MARK: - Injection View Controller
  
  static let homeViewController = ViewControllerFactory {
    let vc = HomeViewController()
    vc.loadViewIfNeeded()
    let reactor = HomeReactor()
    vc.reactor = reactor
    return vc
  }
  static let profileViewController = ViewControllerFactory {
    let vc = ProfileViewController()
    vc.loadViewIfNeeded()
    let reactor = ProfileViewReactor()
    vc.reactor = reactor
    return vc
  }
  static let paymentViewController = ViewControllerFactory { PaymentViewController() }
//  static let detailViewController = Factory<View> { DetailViewController() }
  static let detailViewController = ParameterFactory<String, UIViewController> { id in
    let vc = DetailViewController()
    let reactor = DetailReactor(id: id)
    vc.reactor = reactor
    return vc
  }
  
  // MARK: - Injection Mediator
  
  static let mediator = Factory<MediatorProtocol> { MediatorTarget() }
}
