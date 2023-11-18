//
//  HomeReactor.swift
//  VoltaEel
//
//  Created by Jarvis on 2023/9/22.
//

import RxSwift
import RxCocoa
import RxExtension
import RxDataSources
import ReactorKit
import Factory
import Mediator
import NetworkManager
import Log

public enum HomeModule: Int, IdentifiableType {
  case banner
  case content
  case bottom
  
  public var identity: Int {
    return rawValue
  }
}

public typealias HomeSectionReactor = AnimatableSectionModel<HomeModule, HomeCollectionCellReactor>

public class HomeReactor: Reactor {
  
  public enum Action {
    case headerRefresh
    case footerRefresh
    case update(item: FreeGame)
  }
  
  public enum Mutation {
    case setHeaderRefresh(Bool)
    case setFooterRefresh(Bool)
    case set(items: [HomeSectionReactor])
    case update(item: FreeGame)
  }
  
  public struct State {
    var headerLoading: Bool = false
    var footerLoading: Bool = false
    var items: [HomeSectionReactor] = []
    var dataStatus: DataStatus = .empty
  }
  
  public var initialState: State = .init()
  
  @Injected(Container.mediator) var mediator: MediatorProtocol
  @Injected(Container.homeRequestApi) var network: NetworkManager<HomeRequestApi>
  
  init() {
    network.mode = .debug
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .headerRefresh:
      guard !currentState.headerLoading && !currentState.footerLoading else { return .empty() }
      let startRefreshing = Observable<Mutation>.just(.setHeaderRefresh(true))
      let endRefreshing = Observable<Mutation>.just(.setHeaderRefresh(false))
      let request = requestItems().map { Mutation.set(items: $0) }
      return .concat([startRefreshing, request, endRefreshing])
    case .footerRefresh:
      guard !currentState.headerLoading && !currentState.footerLoading else { return .empty() }
      let startRefreshing = Observable<Mutation>.just(.setFooterRefresh(true))
      let endRefreshing = Observable<Mutation>.just(.setFooterRefresh(false))
      let request = requestItems().map { Mutation.set(items: $0) }
      return .concat([startRefreshing, request, endRefreshing])
    case .update(let homeItem):
      return Observable.just(.update(item: homeItem))
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setHeaderRefresh(isLoading):
      newState.headerLoading = isLoading
    case let .setFooterRefresh(isLoading):
      newState.footerLoading = isLoading
    case let .set(items):
      newState.dataStatus = items.isEmpty ? .empty : .normal
      newState.items = items
    case let .update(homeItem):
      // MARK: - Todo - Update items loved
      printLog("Update items loved")
    }
    return newState
  }
  
  private func convert(_ model: [FreeGame]) -> [HomeSectionReactor] {
    let items = model.map { item in
      HomeCollectionCellReactor(freeGame: item, action: action)
    }
    return [HomeSectionReactor(model: .banner, items: items)]
  }
  
  private func requestItems() -> Observable<[HomeSectionReactor]> {
    return request().map { self.convert($0) }
      .catchAndReturn([])
  }
  
  private func request() -> Observable<[FreeGame]> {
    network.requestObject(.gameList, type: [FreeGame].self)
      .asObservable()
      .do(onError: { error in
        printLog(error)
      })
  }
}
