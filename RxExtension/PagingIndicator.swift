//
//  PagingIndicator.swift
//  RxExtension
//
//  Created by Jarvis on 2022/12/7.
//

import Foundation
import RxSwift
import RxCocoa

protocol Paginable {
  var current: Int { get }
  var pages: Int { get }
}

public final class PagingIndicator: SharedSequenceConvertibleType {
  public typealias SharingStrategy = DriverSharingStrategy
  
  private let _current = BehaviorRelay(value: 1)
  private let _nomore = PublishSubject<Bool>()
  
  var currentPage: Int {
    return _current.value
  }
  
  public init() {}
  
  func trackPage<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
    return source.asObservable()
      .do(onNext: { model in
        guard let model = model as? Paginable else { return }
        self._current.accept(model.current)
        self.onEnding(model.current == model.pages || model.pages == 0)
      }, onError: { _ in
        self.onEnding(true)
      })
        }
  
  public func asSharedSequence() -> SharedSequence<SharingStrategy, Bool> {
    return _nomore.asObservable().asDriverOnErrorJustComplete()
  }
  
  public func asObservable() -> Observable<Bool> {
    return _nomore.asObservable()
  }
  
  private func onEnding(_ ending: Bool) {
    _nomore.onNext(ending)
  }
  
  deinit {
    _nomore.onCompleted()
  }
}

extension ObservableConvertibleType {
  public func trackPage(_ pageIndicator: PagingIndicator) -> Observable<Element> {
    return pageIndicator.trackPage(from: self)
  }
}
