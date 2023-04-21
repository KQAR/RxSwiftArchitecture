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
    let headerRefresh: Signal<Void>
    let footerRefresh: Signal<Void>
    let selection: Signal<HomeCollectionCellViewModel>
  }
  struct Output {
    let sections: Driver<[HomeSectionModel]>
  }
  
  @Injected(Container.mediator) var mediator: MediatorProtocol
  @Injected(Container.homeRequestApi_stubbing) var network: NetworkManager<HomeRequestApi>

  let sectionsRelay = BehaviorRelay<[HomeSectionModel]>(value: [])
  
  func transform(input: Input) -> Output {
    
    input.headerRefresh.asObservable()
      .withUnretained(self)
      .flatMap { owner, _ -> Observable<[HomeSectionModel]> in
        return owner.headerRefresh()
      }
      .subscribe(with: self, onNext: { owner, sections in
        owner.sectionsRelay.accept(sections)
      }).disposed(by: disposeBag)
    
    input.footerRefresh.asObservable()
      .withUnretained(self)
      .flatMap { owner, _ -> Observable<[HomeSectionModel]> in
        return owner.footerRefresh()
      }
      .subscribe(with: self, onNext: { owner, sections in
        var originSections = owner.sectionsRelay.value
        originSections.append(contentsOf: sections)
        let reduceSections = originSections
          .reduce(HomeSectionModel(model: .banner, items: [])) { partialResult, section in
            var reduce = partialResult
            reduce.items.append(contentsOf: section.items)
            return reduce
          }
        owner.sectionsRelay.accept([reduceSections])
      }).disposed(by: disposeBag)
    
    input.selection
      .emit(with: self, onNext: { owner, cellViewModel in
        let id = cellViewModel.homeItem.id
//        owner.mediator.goDetail(id: id)
        owner.mediator.goPayment(id: id, name: "")
      }).disposed(by: disposeBag)
    
    return Output(sections: sectionsRelay.asDriver())
  }
  
  private var loveAction: Binder<HomeItem> {
    Binder(self, scheduler: CurrentThreadScheduler.instance) { owner, homeItem in
      printLog("love tap -> \(homeItem.id) currentThread is \(Thread.current)")
      let newSections = owner.updateItemsLoved(with: homeItem.id)
      owner.sectionsRelay.accept(newSections)
    }
  }
  
  private func updateItemsLoved(with id: String) -> [HomeSectionModel] {
    guard var items = sectionsRelay.value.first else { return [] }
    if let updateItemIndex = items.items.firstIndex(where: { $0.homeItem.id == id }) {
      let removeCellViewModel = items.items.remove(at: updateItemIndex)
      var updateItem = removeCellViewModel.homeItem
      updateItem.updateLoved()
      let newCellViewModel = HomeCollectionCellViewModel(homeItem: updateItem, loveAction: loveAction)
      items.items.insert(newCellViewModel, at: updateItemIndex)
    }
    return [items]
  }
  
  private func convert(_ model: HomeModel) -> [HomeSectionModel] {
    let items = model.items.map { item in
      HomeCollectionCellViewModel(homeItem: item, loveAction: loveAction)
    }
    return [HomeSectionModel(model: .banner, items: items)]
  }
  
  private func headerRefresh() -> Observable<[HomeSectionModel]> {
    return requestItems()
      .track(headerLoading)
      .track(dataStaus)
      .catchAndReturn([])
  }
  
  private func footerRefresh() -> Observable<[HomeSectionModel]> {
    return requestItems()
      .track(footerLoading)
      .catchAndReturn([])
  }
  
  private func requestItems() -> Observable<[HomeSectionModel]> {
    return request().map { self.convert($0) }
  }
  
  private func request() -> Observable<HomeModel> {
    network.requestDeepModel(.homeInfo, type: HomeModel.self)
      .delay(.milliseconds(3000), scheduler: MainScheduler.instance)
      .track(pagingIndicator)
      .track(loading)
      .track(error)
  }
}
