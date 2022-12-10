//
//  Assembly.swift
//  VIPER
//
//  Created by Jarvis on 2022/12/7.
//

import Foundation
import Factory
import BaseView

class Assembly {
  static var homeViewController: UIViewController {
    var vc = Container.homeViewController()
    let viewModel = Container.home()
    vc.tabBarItem.image = UIImage(systemName: "house")
    vc.tabBarItem.title = "home"
    let homeNav = UINavigationController(rootViewController: vc)
    vc.bindViewModel(to: viewModel)
    return homeNav
  }
  
  static var profileViewController: UIViewController {
    var vc = Container.profileViewController()
    let viewModel = Container.profile()
    vc.tabBarItem.image = UIImage(systemName: "person.crop.circle")
    vc.tabBarItem.title = "profile"
    let profileNav = UINavigationController(rootViewController: vc)
    vc.bindViewModel(to: viewModel)
    return profileNav
  }
  
  static func paymentViewController(id: String, name: String) -> UIViewController {
    let viewModel = Container.payment((id: id, name: name))
    var vc = Container.paymentViewController()
    vc.bindViewModel(to: viewModel)
    return vc
  }
}
