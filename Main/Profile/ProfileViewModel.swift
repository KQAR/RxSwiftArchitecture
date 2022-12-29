//
//  ProfileViewModel.swift
//  VIPER
//
//  Created by Jarvis on 2022/12/7.
//

import Foundation
import RxSwift
import RxCocoa
import Bindable
import Factory
import Mediator
import NetworkManager

class ProfileViewModel: ViewModel, ViewModelType {
  
  struct Input {
    let headerRefresh: Observable<Void>
    let footerRefresh: Observable<Void>
  }
  struct Output {
    let items: Observable<[ProfileTableViewCellViewModel]>
  }
  
  @Injected(Container.mediator) var mediator: MediatorProtocol
  @Injected(Container.profileRequestApi_stubbing) var network: NetworkManager<ProfileRequestApi>
  
  func transform(input: Input) -> Output {
    let itemsRelay = BehaviorRelay<[ProfileTableViewCellViewModel]>(value: [])
    
    input.headerRefresh
      .withUnretained(self)
      .flatMap { owner, _ -> Observable<[ProfileTableViewCellViewModel]> in
        return owner.request()
          .track(owner.headerLoading)
          .track(owner.dataStaus)
      }.subscribe(onNext: { items in
        itemsRelay.accept(items)
      }).disposed(by: disposeBag)
    input.footerRefresh
      .withUnretained(self)
      .flatMap { owner, _ -> Observable<[ProfileTableViewCellViewModel]> in
        return owner.request()
          .track(owner.footerLoading)
      }.subscribe(onNext: { items in
        var originItems = itemsRelay.value
        originItems.append(contentsOf: items)
        itemsRelay.accept(originItems)
      }).disposed(by: disposeBag)
    
    return Output(items: itemsRelay.asObservable())
  }
  
  func request() -> Observable<[ProfileTableViewCellViewModel]> {
    return network.requestDeepModel(.userInfo, type: ProfileModel.self)
      .track(pagingIndicator)
      .track(loading)
      .track(error)
      .map { profileModel in
        profileModel.userInfos.map { userInfo in
          ProfileTableViewCellViewModel(userInfo: userInfo)
        }
      }
      .catchAndReturn([])
  }
}
