//
//  Assembly.swift
//  VIPER
//
//  Created by Jarvis on 2022/12/7.
//

import UIKit
import Foundation
import Factory
import BaseView

class Assembly {
  static var tabbarController: UIViewController {
    let tabbarItem = Container.tabItems()
    let tabBarController = Container.tabBar()
    tabBarController.set(itemsAssembly: tabbarItem)
    return tabBarController
  }
  
  static var homeViewController: UIViewController {
    var vc = Container.homeViewController()
    let viewModel = Container.home()
    let homeNav = NavigationController(rootViewController: vc)
    vc.bindViewModel(to: viewModel)
    return homeNav
  }
  
  static var profileViewController: UIViewController {
    var vc = Container.profileViewController()
    let viewModel = Container.profile()
    let profileNav = NavigationController(rootViewController: vc)
    vc.bindViewModel(to: viewModel)
    return profileNav
  }
  
  static func paymentViewController(id: String, name: String) -> UIViewController {
    let viewModel = Container.payment((id: id, name: name))
    var vc = Container.paymentViewController()
    vc.bindViewModel(to: viewModel)
    return vc
  }
  
  static func detailViewController(id: String) -> UIViewController {
//    let viewModel = Container.detail(id)
//    var vc = Container.detailViewController()
//    vc.bindViewModel(to: viewModel)
//    return vc
    return Container.detailViewController(id)
  }
}
