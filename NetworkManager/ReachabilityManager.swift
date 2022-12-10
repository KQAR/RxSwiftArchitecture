//
//  ReachabilityManager.swift
//  NetworkManager
//
//  Created by 金瑞 on 2022/12/10.
//

import Foundation
import Alamofire
import RxSwift

final class ReachabilityManager: NSObject {
  
  static let shared = ReachabilityManager()
  
  let reachSubject = ReplaySubject<Bool>.create(bufferSize: 1)
  var reach: Observable<Bool> {
    return reachSubject.asObservable()
  }
  
  override init() {
    super.init()
    NetworkReachabilityManager.default?.startListening(onUpdatePerforming: { status in
      switch status {
      case .notReachable:
        self.reachSubject.onNext(false)
      case .reachable:
        self.reachSubject.onNext(true)
      case .unknown:
        self.reachSubject.onNext(false)
      }
    })
  }
}
