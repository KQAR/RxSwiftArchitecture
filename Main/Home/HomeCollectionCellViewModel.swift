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

class HomeCollectionCellViewModel: IdentifiableViewModel {
  
  let homeItem: HomeItem
  
  let cover: Driver<URL?>
  let title: Driver<String?>
  let content: Driver<String?>
  
  init(identify: UUID = UUID(), homeItem: HomeItem) {
    self.homeItem = homeItem
    self.cover = Observable.just(URL(string: homeItem.cover.or(""))).asDriver(onErrorJustReturn: nil)
    self.title = Observable.just(homeItem.title).asDriver(onErrorJustReturn: nil)
    self.content = Observable.just(homeItem.content).asDriver(onErrorJustReturn: nil)
    super.init(identity: identify)
  }
}
