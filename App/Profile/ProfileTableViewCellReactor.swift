//
//  ProfileTableViewCellReactor.swift
//  VoltaEel
//
//  Created by Jarvis on 2023/9/22.
//

import Foundation
import ReactorKit
import Bindable

public class ProfileTableViewCellReactor: IdentifiableViewModel, Reactor {
  
  public typealias Action = Never
  public typealias Mutation = Never
  
  public struct State {
    let userInfo: UserInfo
  }
  
  public let initialState: State
  
  init(identity: UUID = UUID(), userInfo: UserInfo) {
    initialState = State(userInfo: userInfo)
    super.init(identity: identity)
  }
}
