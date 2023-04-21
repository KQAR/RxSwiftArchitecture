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
    let headerRefresh: Signal<Void>
    let footerRefresh: Signal<Void>
  }
  struct Output {
    let items: Driver<[ProfileTableViewCellViewModel]>
  }
  
  @Injected(Container.mediator) var mediator: MediatorProtocol
  @Injected(Container.profileRequestApi_stubbing) var network: NetworkManager<ProfileRequestApi>
  
  func transform(input: Input) -> Output {
    let itemsRelay = BehaviorRelay<[ProfileTableViewCellViewModel]>(value: [])
    
    input.headerRefresh.asObservable()
      .withUnretained(self)
      .flatMap { owner, _ -> Observable<[ProfileTableViewCellViewModel]> in
        owner.headerRefresh()
      }.subscribe(onNext: { items in
        itemsRelay.accept(items)
      }).disposed(by: disposeBag)
    
    input.footerRefresh.asObservable()
      .withUnretained(self)
      .flatMap { owner, _ -> Observable<[ProfileTableViewCellViewModel]> in
        owner.footerRefresh()
      }.subscribe(onNext: { items in
        var originItems = itemsRelay.value
        originItems.append(contentsOf: items)
        itemsRelay.accept(originItems)
      }).disposed(by: disposeBag)
    
    return Output(items: itemsRelay.asDriver())
  }
  
  private func headerRefresh() -> Observable<[ProfileTableViewCellViewModel]> {
    return request()
      .track(headerLoading)
      .track(dataStaus)
      .catchAndReturn([])
  }
  
  private func footerRefresh() -> Observable<[ProfileTableViewCellViewModel]> {
    return request()
      .track(footerLoading)
      .catchAndReturn([])
  }
  
  private func request() -> Observable<[ProfileTableViewCellViewModel]> {
    return network.requestDeepModel(.userInfo, type: ProfileModel.self)
      .track(pagingIndicator)
      .track(loading)
      .track(error)
      .map { profileModel in
        profileModel.userInfos.map { userInfo in
          ProfileTableViewCellViewModel(userInfo: userInfo)
        }
      }
  }
}
