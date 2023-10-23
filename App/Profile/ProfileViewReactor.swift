//
//  ProfileViewReactor.swift
//  VoltaEel
//
//  Created by Jarvis on 2023/9/22.
//

import RxSwift
import RxCocoa
import RxExtension
import ReactorKit
import Factory
import Mediator
import NetworkManager
import Foundation

public class ProfileViewReactor: Reactor {
  
  public enum Action {
    case headerRefresh
    case footerRefresh
  }
  
  public enum Mutation {
    case setHeaderRefresh(Bool)
    case setFooterRefresh(Bool)
    case set(items: [ProfileTableViewCellReactor])
  }
  
  public struct State {
    var headerLoading: Bool = false
    var footerLoading: Bool = false
    var items: [ProfileTableViewCellReactor] = []
    var dataStatus: DataStatus = .empty
  }
  
  public var initialState: State = .init()
  
  @Injected(Container.mediator) var mediator: MediatorProtocol
  @Injected(Container.profileRequestApi_stubbing) var network: NetworkManager<ProfileRequestApi>
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .headerRefresh:
      guard !currentState.headerLoading && !currentState.footerLoading else { return .empty() }
      let startRefreshing = Observable<Mutation>.just(.setHeaderRefresh(true))
      let endRefreshing = Observable<Mutation>.just(.setHeaderRefresh(false))
      let request = request().map { Mutation.set(items: $0) }
      return .concat([startRefreshing, request, endRefreshing])
    case .footerRefresh:
      guard !currentState.headerLoading && !currentState.footerLoading else { return .empty() }
      let startRefreshing = Observable<Mutation>.just(.setFooterRefresh(true))
      let endRefreshing = Observable<Mutation>.just(.setFooterRefresh(false))
      let request = request().map { Mutation.set(items: $0) }
      return .concat([startRefreshing, request, endRefreshing])
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .set(items: let items):
      newState.items = items
    case .setHeaderRefresh(let headerLoading):
      newState.headerLoading = headerLoading
    case .setFooterRefresh(let footerLoading):
      newState.footerLoading = footerLoading
    }
    return newState
  }
  
  private func request() -> Observable<[ProfileTableViewCellReactor]> {
    return network.requestDeepModel(.userInfo, type: ProfileModel.self)
      .asObservable()
      .map { profileModel in
        profileModel.userInfos.map { userInfo in
          ProfileTableViewCellReactor(userInfo: userInfo)
        }
      }
      .catchAndReturn([])
  }
}
