//
//  MediatorAction.swift
//  VIPER
//
//  Created by Jarvis on 2022/12/7.
//

import Foundation
import Factory
import ViewControllerManager

class MediatorAction: MediatorActionProtocol {
  func goPayment(id: String, name: String) {
    let vc = Assembly.paymentViewController(id: id, name: name)
    ViewControllerManager.pushToViewCotntroller(toVC: vc)
  }
  func goDetail(id: String) {
    let vc = Assembly.detailViewController(id: id)
    ViewControllerManager.pushToViewCotntroller(toVC: vc)
  }
}
