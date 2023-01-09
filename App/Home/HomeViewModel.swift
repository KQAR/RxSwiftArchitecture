//
//  HomeViewModel.swift
//  VIPER
//
//  Created by Jarvis on 2022/12/7.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Factory
import Mediator
import Bindable
import NetworkManager
import Log

enum HomeModule: Int, IdentifiableType {
  case banner
  case content
  case bottom
  
  var identity: Int {
    return rawValue
  }
}

typealias HomeSectionModel = AnimatableSectionModel<HomeModule, HomeCollectionCellViewModel>

final class HomeViewModel: ViewModel, ViewModelType {
  
  struct Input {
    let headerRefresh: Observable<Void>
    let footerRefresh: Observable<Void>
    let selection: Observable<HomeCollectionCellViewModel>
  }
  struct Output {
    let sections: Observable<[HomeSectionModel]>
  }
  
  @Injected(Container.mediator) var mediator: MediatorProtocol
  @Injected(Container.homeRequestApi_stubbing) var network: NetworkManager<HomeRequestApi>
  
  private var faveObserver: AnyObserver<HomeItem> {
    AnyObserver { [weak self] event in
      switch event {
      case .next(let homeItem):
        self?.faveAction(with: homeItem)
      default:
        fatalError()
      }
    }
  }
  
  func transform(input: Input) -> Output {
    let sectionsRelay = BehaviorRelay<[HomeSectionModel]>(value: [])
    
    input.headerRefresh
      .withUnretained(self)
      .flatMap { owner, _ -> Observable<[HomeSectionModel]> in
        return owner.requestItems()
          .track(owner.headerLoading)
          .track(owner.dataStaus)
          .catchAndReturn([])
      }.subscribe(onNext: { sections in
        sectionsRelay.accept(sections)
      }).disposed(by: disposeBag)
    input.footerRefresh
      .withUnretained(self)
      .flatMap { owner, _ -> Observable<[HomeSectionModel]> in
        return owner.requestItems()
          .track(owner.footerLoading)
          .catchAndReturn([])
      }.subscribe(onNext: { sections in
        var originSections = sectionsRelay.value
        originSections.append(contentsOf: sections)
        let reduceSections = originSections
          .reduce(HomeSectionModel(model: .banner, items: [])) { partialResult, section in
            var reduce = partialResult
            reduce.items.append(contentsOf: section.items)
            return reduce
          }
        sectionsRelay.accept([reduceSections])
      }).disposed(by: disposeBag)
    input.selection
      .withUnretained(self)
      .subscribe(onNext: { owner, cellViewModel in
        let id = cellViewModel.homeItem.id.or("")
        owner.mediator.goDetail(id: id)
      }).disposed(by: disposeBag)
    
    return Output(sections: sectionsRelay.asObservable())
  }
    
  private func convert(_ model: HomeModel) -> [HomeSectionModel] {
    let items = model.items.map { item in
      HomeCollectionCellViewModel(homeItem: item, faveObserver: faveObserver)
    }
    return [HomeSectionModel(model: .banner, items: items)]
  }
  
  private func faveAction(with: HomeItem) {
    // To-do: save fave item
    printLog("fave ~")
  }
  
  private func requestItems() -> Observable<[HomeSectionModel]> {
    request().map { self.convert($0) }
  }
  
  private func request() -> Observable<HomeModel> {
    network.requestDeepModel(.homeInfo, type: HomeModel.self)
      .delay(.milliseconds(3000), scheduler: MainScheduler.instance)
      .track(pagingIndicator)
      .track(loading)
      .track(error)
  }
}
