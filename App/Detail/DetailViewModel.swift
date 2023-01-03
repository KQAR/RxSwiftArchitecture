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
import Popups

final class DetailViewModel: ViewModel, ViewModelType {
  
  public struct Input {
    let refresh: Observable<Void>
    let collect: Observable<Void>
    let wireframe: Wireframe
  }
  public struct Output {
    let title: Driver<String?>
    let cover: Driver<URL?>
    let content: Driver<String?>
    let isCollected: Driver<Bool>
    let isCollectHidden: Driver<Bool>
    let tips: Observable<String>
  }
  
  private let id: String
  
  @Injected(Container.mediator) var mediator: MediatorProtocol
  @Injected(Container.homeRequestApi_stubbing) var network: NetworkManager<HomeRequestApi>
  
  init(_ id: String) {
    self.id = id
    super.init()
    network.mode = .debug
  }
  
  public func transform(input: Input) -> Output {
    let element = BehaviorRelay<Detail?>(value: nil)
    let tips = PublishRelay<String>()
    
    func collect(_ success: Bool) {
      if success {
        var detail = element.value
        detail?.collection?.toggle()
        element.accept(detail)
      } else {
        tips.accept("操作失败")
      }
    }
    
    input.refresh
      .withUnretained(self)
      .flatMap { owner, _ in
        return owner.request(id: owner.id)
      }.subscribe(onNext: { model in
        element.accept(model)
      }).disposed(by: disposeBag)
    
    input.collect
      .withLatestFrom(element)
      .flatMap({ defail -> Observable<(Bool, Detail?)> in
        var title = (defail?.collection).or(false) ? "是否取消收藏" : "是否确认收藏"
        return input.wireframe.promptFor(
          title,
          cancelAction: DefaultWireframeAction.cancel,
          actions: [DefaultWireframeAction.ensure]
        )
          .map { ($0.confirm, defail) }
      })
      .withUnretained(self)
      .flatMap { owner, arg -> Observable<Bool> in
        let (confirm, detail) = arg
        if confirm {
          return owner.collectOperation(id: (detail?.id).or(""), isCollect: !(detail?.collection).or(false))
        }
        return .empty()
      }.subscribe(onNext: { success in
        collect(success)
      }).disposed(by: disposeBag)
    
    
    let title = element.map { $0?.title }
      .asDriver(onErrorJustReturn: nil)
    let cover = element.map { URL(string: ($0?.cover).or("")) }
      .asDriver(onErrorJustReturn: nil)
    let content = element.map { $0?.content }
      .asDriver(onErrorJustReturn: nil)
    let isCollected = element.map { ($0?.collection).or(false) }
      .asDriver(onErrorJustReturn: false)
    let isCollectedHidden = element.map { $0 == nil }
      .asDriver(onErrorJustReturn: false)
    
    return Output(
      title: title,
      cover: cover,
      content: content,
      isCollected: isCollected,
      isCollectHidden: isCollectedHidden,
      tips: tips.asObservable()
    )
  }
  
  /// 页面数据的网络请求
  /// - Parameter id: 页面相关数据的 id
  /// - Returns: 页面数据的可观察序列
  private func request(id: String) -> Observable<Detail> {
    network.requestDeepModel(.detail(id: id), type: Detail.self)
      .delay(.milliseconds(2000), scheduler: MainScheduler.instance)
      .track(pagingIndicator)
      .track(loading)
      .track(error)
      .catchAndReturn(Detail())
  }
  
  /// 收藏操作的网络请求
  /// - Parameters:
  ///   - id: 收藏对象的 id
  ///   - isCollect: true 为收藏，false 为取消收藏
  /// - Returns: 返回操作结果，true 成功，false 失败
  private func collectOperation(id : String, isCollect: Bool) -> Observable<Bool> {
    return Observable.just(true)
  }
}
