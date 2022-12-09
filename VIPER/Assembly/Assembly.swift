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
  static var homeViewController: ViewController {
    var vc = Container.homeViewController()
    let viewModel = Container.home()
    vc.bindViewModel(to: viewModel)
    return vc
  }
  
  static var profileViewController: ViewController {
    var vc = Container.profileViewController()
    let viewModel = Container.profile()
    vc.bindViewModel(to: viewModel)
    return vc
  }
  
  static func paymentViewController(id: String, name: String) -> ViewController {
    let viewModel = Container.payment((id: id, name: name))
    var vc = Container.paymentViewController()
    vc.bindViewModel(to: viewModel)
    return vc
  }
}
