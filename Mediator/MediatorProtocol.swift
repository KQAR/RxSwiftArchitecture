//
//  MediatorProtocol.swift
//  Mediator
//
//  Created by Jarvis on 2022/12/6.
//

import Foundation

public protocol MediatorProtocol {
  func goPayment(id: String, name: String)
  func goDetail(id: String)
}
