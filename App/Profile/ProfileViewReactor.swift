//
//  ProfileViewReactor.swift
//  VoltaEel
//
//  Created by Jarvis on 2023/9/22.
//

import RxSwift
import RxCocoa
import ReactorKit
import Factory
import Mediator
import NetworkManager
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
  
  @Injected(Container.mediator) var mediator: MediatorProtocol
  @Injected(Container.profileRequestApi_stubbing) var network: NetworkManager<ProfileRequestApi>
  
  func reduce(state: State, mutation: Mutation) -> State {
    return State()
  }
  
  private func headerRefresh() -> Infallible<[ProfileTableViewCellReactor]> {
    return request()
      .asInfallible(onErrorJustReturn: [])
  }
  
  private func footerRefresh() -> Infallible<[ProfileTableViewCellReactor]> {
    return request()
      .asInfallible(onErrorJustReturn: [])
  }
  
  private func request() -> Observable<[ProfileTableViewCellReactor]> {
    return network.requestDeepModel(.userInfo, type: ProfileModel.self)
      .asObservable()
      .map { profileModel in
        profileModel.userInfos.map { userInfo in
          ProfileTableViewCellReactor(userInfo: userInfo)
        }
      }
  }
}
