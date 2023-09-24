//
//  ProfileTableViewCellReactor.swift
//  VoltaEel
//
//  Created by Jarvis on 2023/9/22.
//

import Foundation
import ReactorKit
import Bindable

class ProfileTableViewCellReactor: IdentifiableViewModel, Reactor {
  
  typealias Action = Never
  typealias Mutation = Never
  
  struct State {
    let userInfo: UserInfo
  }
  
  let initialState: State
  
  init(identity: UUID = UUID(), userInfo: UserInfo) {
    initialState = State(userInfo: userInfo)
    super.init(identity: identity)
  }
}
