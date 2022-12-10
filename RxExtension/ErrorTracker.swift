//
//  ErrorTracker.swift
//  RxExtension
//
//  Created by Jarvis on 2022/12/7.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
  func asDriverOnErrorJustComplete() -> Driver<Element> {
    return asDriver { error in
      assertionFailure("Error \(error)")
      return Driver.empty()
    }
  }
}

public final class ErrorTracker: SharedSequenceConvertibleType {
  public typealias SharingStrategy = DriverSharingStrategy
  private let _subject = PublishSubject<Error>()
  
  public init() {}
  
  func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
    return source.asObservable().do(onError: onError)
      }
  
  public func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
    return _subject.asObservable().asDriverOnErrorJustComplete()
  }
  
  public func asObservable() -> Observable<Error> {
    return _subject.asObservable()
  }
  
  private func onError(_ error: Error) {
    _subject.onNext(error)
  }
  
  deinit {
    _subject.onCompleted()
  }
}

extension ObservableConvertibleType {
  public func trackError(_ errorTracker: ErrorTracker) -> Observable<Element> {
    return errorTracker.trackError(from: self)
  }
}
