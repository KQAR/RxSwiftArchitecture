//
//  ProfileViewReactor.swift
//  VoltaEel
//
//  Created by Jarvis on 2023/9/22.
//

import RxSwift
import RxCocoa
import ReactorKit
import Foundation

class ProfileViewReactor: Reactor {
  
  enum Action {
    case headerRefresh
    case footerRefresh
  }
  
  enum Mutation {
    case set(item: String)
  }
  
  struct State {
    var headerLoading: Bool = false
    var footerLoading: Bool = false
    var items: [ProfileTableViewCellReactor] = []
  }
  
  var initialState: State = .init()
  
  func reduce(state: State, mutation: Mutation) -> State {
    return State()
  }
}
