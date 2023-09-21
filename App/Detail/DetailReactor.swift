//
//  DetailReactor.swift
//  VoltaEel
//
//  Created by Jarvis on 2023/9/13.
//

import Factory
import Foundation
import ReactorKit
import Mediator
import NetworkManager
import Popups

final class DetailReactor: Reactor {
  
  enum Action {
    case refresh
    case collect
  }
  
  enum Mutation {
    case set(detail: Detail?)
    case collect(Bool)
    case setTips(String)
  }
  
  struct State {
    let id: String
    var detail: Detail?
    var isCollect: Bool?
    @Pulse var tips: String?
  }
  
  let initialState: State
  
  @Injected(Container.mediator) var mediator: MediatorProtocol
  @Injected(Container.homeRequestApi_stubbing) var network: NetworkManager<HomeRequestApi>
  
  init(id: String) {
    self.initialState = State(id: id)
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .refresh:
      return request(id: initialState.id)
        .map { .set(detail: $0) }
    case .collect:
      let collect = collect(id: initialState.id)
      return Observable.concat([
        collect
          .map{ .setTips($0 ? "收藏成功": "收藏失败") },
        collect
          .map { _ in .collect(true) }
      ])
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .set(detail):
      newState.detail = detail
    case let .collect(isCollect):
      newState.isCollect = isCollect
    case let .setTips(tip):
      newState.tips = tip
    }
    return newState
  }
  
  /// 页面数据的网络请求
  /// - Parameter id: 页面相关数据的 id
  /// - Returns: 页面数据的可观察序列
  private func request(id: String) -> Observable<Detail?> {
    network.requestDeepModel(.detail(id: id), type: Detail?.self)
      .delay(.milliseconds(2000), scheduler: MainScheduler.instance)
      .asObservable()
      .catchAndReturn(nil)
  }
  
  private func collect(id: String) -> Observable<Bool> {
    return Observable.just(true)
  }
}
