//
//  OnlineProvider.swift
//  NetworkManager
//
//  Created by 金瑞 on 2022/12/10.
//

import Foundation
import RxSwift
import Moya
import Log
import SwiftyJSON

public class OnlineProvider<Target> where Target: Moya.TargetType {
  fileprivate let online: Observable<Bool>
  fileprivate let provider: MoyaProvider<Target>
  
  public var mode: Mode = .normal
  
  private var isDebugging: Bool {
    #if DEBUG
    return mode == .debug
    #else
    return false
    #endif
  }
  
  init(
    endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider<Target>.defaultEndpointMapping,
    requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
    stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider<Target>.neverStub,
    callbackQueue: DispatchQueue? = nil,
    session: Session = MoyaProvider<Target>.defaultAlamofireSession(),
    plugins: [PluginType] = [],
    trackInflights: Bool = false,
    online: Observable<Bool> = ReachabilityManager.shared.reach
  ) {
    self.online = online
    self.provider = MoyaProvider(
      endpointClosure: endpointClosure,
      requestClosure: requestClosure,
      stubClosure: stubClosure,
      callbackQueue: callbackQueue,
      session: session,
      plugins: plugins,
      trackInflights: trackInflights
    )
  }
  
  func request(_ token: Target) -> Observable<Moya.Response> {
    let actualRequest = provider.rx.request(token)
    return online
      .filter { $0 }
      .take(1)
      .flatMap { _ in
        return actualRequest
          .filterSuccessfulStatusCodes()
          .do(onSuccess: { (response) in
            if self.isDebugging {
              let json = JSON(response.data)
              printLog(json, tags: .network, .success)
            }
          }, onError: { (error) in
            if self.isDebugging, let error = error as? MoyaError {
              printLog(error, tags: .network, .failure)
            }
          })
      }
  }
}

extension OnlineProvider {
  public enum Mode {
    case normal
    case debug
  }
}
