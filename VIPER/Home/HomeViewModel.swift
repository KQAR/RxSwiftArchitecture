//
//  HomeViewModel.swift
//  VIPER
//
//  Created by Jarvis on 2022/12/7.
//

import Foundation
import RxSwift
import RxDataSources
import Factory
import Mediator
import Bindable

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
  
  func transform(input: Input) -> Output {
    input.selection
      .withUnretained(self)
      .subscribe(onNext: { owner, _ in
        owner.mediator.goPayment(id: "", name: "")
      }).disposed(by: disposeBag)
    return Output(sections: Observable.just([HomeSectionModel(model: .banner, items: [HomeCollectionCellViewModel()])]))
  }
}
