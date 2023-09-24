//
//  ProfileTableViewCellReactor.swift
//  VoltaEel
//
//  Created by Jarvis on 2023/9/22.
//

import Foundation
import ReactorKit

class ProfileTableViewCellReactor: Reactor {
  
  typealias Action = Never
  typealias Mutation = Never
  
  struct State {
    let userInfo: UserInfo
  }
  
  let initialState: State
  
  init(userInfo: UserInfo) {
    initialState = State(userInfo: userInfo)
  }
}
