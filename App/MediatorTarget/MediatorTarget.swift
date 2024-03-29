//
//  MediatorTarget.swift
//  VIPER
//
//  Created by Jarvis on 2022/12/7.
//

import Foundation
import Mediator
import BaseView
import Factory

public class MediatorTarget: MediatorProtocol {
  public func goPayment(id: String, name: String) {
    let action = VoltaEel.MediatorAction()
    action.goPayment(id: id, name: name)
  }
  public func goDetail(id: String) {
    let action = VoltaEel.MediatorAction()
    action.goDetail(id: id)
  }
}
