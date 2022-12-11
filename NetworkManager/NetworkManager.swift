//
//  NetworkManager.swift
//  NetworkManager
//
//  Created by 金瑞 on 2022/12/10.
//

import Foundation
import Moya

public struct NetworkManager<T: TargetType>: NetworkManagerType {
  
  public let provider: OnlineProvider<T>
  
  /// 默认网络
  public static func defaultNetworking() -> Self {
    return NetworkManager(provider: newProvider(plugins))
  }
  
  /// 本地数据测试
  public static func stubbingNetworking() -> Self {
    return NetworkManager(
      provider: OnlineProvider(
        endpointClosure: endpointsClosure(),
        requestClosure: endpointResolver(),
        stubClosure: MoyaProvider.delayedStub(1.0),
        online: .just(true)
      )
    )
  }
}
