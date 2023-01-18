//
//  HomeCollectionCellViewModel.swift
//  VIPER
//
//  Created by Jarvis on 2022/12/7.
//

import Foundation
import Bindable
import Extension
import RxSwift
import RxCocoa

final class HomeCollectionCellViewModel: IdentifiableViewModel {
  
  let homeItem: HomeItem
  
  let cover: Driver<URL?>
  let title: Driver<String?>
  let content: Driver<String?>
  let beloved: Driver<Bool>
  
  let loveAction: AnyObserver<HomeItem>
  
  init(identify: UUID = UUID(), homeItem: HomeItem, loveAction: AnyObserver<HomeItem>) {
    self.homeItem = homeItem
    self.loveAction = loveAction
    self.cover = Observable.just(URL(string: homeItem.cover.or(""))).asDriver(onErrorJustReturn: nil)
    self.title = Observable.just(homeItem.title).asDriver(onErrorJustReturn: nil)
    self.content = Observable.just(homeItem.content).asDriver(onErrorJustReturn: nil)
    self.beloved = Observable.just(homeItem.beloved.or(false)).asDriver(onErrorJustReturn: false)
    super.init(identity: identify)
  }
}
