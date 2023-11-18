//
//  HomeCollectionCellReactor.swift
//  VoltaEel
//
//  Created by Jarvis on 2023/10/24.
//

import Extension
import RxSwift
import RxCocoa
import ReactorKit
import Bindable
import Log

public class HomeCollectionCellReactor: IdentifiableViewModel, Reactor {
  
  public enum Action {
    case likeTap
  }
  
  public enum Mutation {
    case likeToggle
  }
  
  public struct State {
    var freeGame: FreeGame
  }
  
  public let initialState: State
  private let homeAction: ActionSubject<HomeReactor.Action>
  
  init(identity: UUID = UUID(), freeGame: FreeGame, action: ActionSubject<HomeReactor.Action>) {
    initialState = State(freeGame: freeGame)
    homeAction = action
    super.init(identity: identity)
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .likeTap:
      homeAction.onNext(.update(item: currentState.freeGame))
      return Observable.just(.likeToggle)
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .likeToggle:
//      newState.homeItem.updateLoved()
      printLog("d")
    }
    return newState
  }
}
