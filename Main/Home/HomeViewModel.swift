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

class HomeViewModel: ViewModel, ViewModelType {
  
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
  
  func transform(input: Input) -> Output {
    let sectionsRelay = BehaviorRelay<[HomeSectionModel]>(value: [])
    
    input.headerRefresh
      .withUnretained(self)
      .flatMap { owner, _ -> Observable<[HomeSectionModel]> in
        return owner.request()
          .delay(.milliseconds(3000), scheduler: MainScheduler.instance)
          .trackActivity(owner.headerLoading)
      }.subscribe(onNext: { sections in
        sectionsRelay.accept(sections)
      }).disposed(by: disposeBag)
    input.footerRefresh
      .withUnretained(self)
      .flatMap { owner, _ -> Observable<[HomeSectionModel]> in
        return owner.request()
          .trackActivity(owner.footerLoading)
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
      .subscribe(onNext: { owner, _ in
        owner.mediator.goPayment(id: "", name: "")
      }).disposed(by: disposeBag)
    
    return Output(sections: sectionsRelay.asObservable())
  }
  
  func request() -> Observable<[HomeSectionModel]> {
    network.requestDeepModel(.homeInfo, type: HomeModel.self)
      .trackPage(pagingIndicator)
      .trackActivity(loading)
      .trackError(error)
      .map { homeModel in
        let items = homeModel.items.map { item in
          HomeCollectionCellViewModel(homeItem: item)
        }
        return [HomeSectionModel(model: .banner, items: items)]
      }
  }
}
