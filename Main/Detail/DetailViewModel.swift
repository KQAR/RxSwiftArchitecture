//
//  DetailViewModel.swift
//  VoltaEel
//
//  Created by Jarvis on 2022/12/30.
//

import Foundation
import RxSwift
import RxCocoa
import Factory
import Mediator
import NetworkManager
import Bindable

class DetailViewModel: ViewModel, ViewModelType {
  
  public struct Input {
    let refresh: Observable<Void>
  }
  public struct Output {
    let title: Driver<String?>
    let cover: Driver<URL?>
    let content: Driver<String?>
  }
  
  private let id: String
  
  @Injected(Container.mediator) var mediator: MediatorProtocol
  @Injected(Container.homeRequestApi_stubbing) var network: NetworkManager<HomeRequestApi>
  
  init(_ id: String) {
    self.id = id
    super.init()
  }
  
  public func transform(input: Input) -> Output {
    let element = BehaviorRelay<Detail?>(value: nil)
    
    input.refresh
      .withUnretained(self)
      .flatMap { owner, _ in
        return owner.request(id: owner.id)
      }.subscribe(onNext: { model in
        element.accept(model)
      }).disposed(by: disposeBag)
    
    let title = element.map { $0?.title }.asDriver(onErrorJustReturn: nil)
    let cover = element.map { URL(string: ($0?.cover).or("")) }.asDriver(onErrorJustReturn: nil)
    let content = element.map { $0?.content }.asDriver(onErrorJustReturn: nil)
    
    return Output(title: title, cover: cover, content: content)
  }
  
  private func request(id: String) -> Observable<Detail> {
    network.requestDeepModel(.detail(id: id), type: Detail.self)
      .track(pagingIndicator)
      .track(loading)
      .track(error)
      .catchAndReturn(Detail())
  }
}
