//
//  DataStatusTracker.swift
//  RxExtension
//
//  Created by 金瑞 on 2022/12/29.
//

import Foundation
import RxSwift
import RxCocoa

public protocol DataStatusPresentable {
  var dataStatus: DataStatus { get }
}

extension Array: DataStatusPresentable {}
extension Dictionary: DataStatusPresentable {}
extension DataStatusPresentable where Self: Collection {
  public var dataStatus: DataStatus {
    return isEmpty ? .empty : .normal
  }
}

public enum DataStatus {
  case normal
  case empty
  case error(Error)
}

public final class DataStatusTracker: SharedSequenceConvertibleType {
  public typealias SharingStrategy = DriverSharingStrategy
  private let _subject = PublishSubject<DataStatus>()
  
  public init() {}
  
  func track<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
    return source.asObservable().do(onNext: { model in
      guard let model = model as? DataStatusPresentable else { return }
      self._subject.onNext(model.dataStatus)
    }, onError: { error in
      self.onError(error)
    })
  }
  
  public func asSharedSequence() -> SharedSequence<SharingStrategy, DataStatus> {
    return _subject.asObservable().asDriverOnErrorJustComplete()
  }
  
  public func asObservable() -> Observable<DataStatus> {
    return _subject.asObservable()
  }
  
  private func onError(_ error: Error) {
    _subject.onNext(.error(error))
  }
  
  deinit {
    _subject.onCompleted()
  }
}

extension ObservableConvertibleType {
  public func track(_ dataStatusTracker: DataStatusTracker) -> Observable<Element> {
    return dataStatusTracker.track(from: self)
  }
}
