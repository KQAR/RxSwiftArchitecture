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

class ProfileViewModel: ViewModel, ViewModelType {
  struct Input {
    let headerRefresh: Observable<Void>
    let footerRefresh: Observable<Void>
  }
  struct Output {
    let items: Observable<[ProfileTableViewCellViewModel]>
  }
  
  func transform(input: Input) -> Output {
    return Output(items: Observable.just([]))
  }
}
