//
//  MediatorActionProtocol.swift
//  VIPER
//
//  Created by Jarvis on 2022/12/7.
//

import Foundation

protocol MediatorActionProtocol {
  func goPayment(id: String, name: String)
  func goDetail(id: String)
}
