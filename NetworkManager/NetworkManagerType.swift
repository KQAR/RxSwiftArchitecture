//
//  NetworkManagerType.swift
//  NetworkManager
//
//  Created by 金瑞 on 2022/12/10.
//

import Foundation
import RxSwift
import Moya
import Log

public protocol NetworkManagerType {
  associatedtype T: TargetType
  var provider: OnlineProvider<T> { get }
  
  static func defaultNetworking() -> Self
  static func stubbingNetworking() -> Self
}

extension NetworkManagerType {
  static var plugins: [PluginType] {
    var plugins: [PluginType] = []
    
#if DEBUG
    let LoadingPlugin = NetworkActivityPlugin { (type, target) in
      switch type {
      case .began:
        printLog("[===> NETWORKING BEGIN", type: .network)
        switch target.task {
        case .requestJSONEncodable(let model):
          printLog("[===> Task: \(model)", type: .network)
        case .requestParameters(let parameters, let encoding):
          printLog("[===> Task: \(encoding) parameters: ===> \(parameters)", type: .network)
        default:
          printLog("[===> Task: \(target.task)", type: .network)
        }
      case .ended:
        printLog("[===> NETWORKING END", type: .network)
      }
    }
    plugins.append(LoadingPlugin)
    
    let loggerPlugin = NetworkLoggerPlugin()
    plugins.append(loggerPlugin)
#endif
    
    return plugins
  }
  
  static func newProvider<T>(_ plugins: [PluginType], xAccessToken: String? = nil) -> OnlineProvider<T> where T: TargetType {
    return OnlineProvider(
      endpointClosure: Self.endpointsClosure(xAccessToken),
      requestClosure: Self.endpointResolver(),
      plugins: plugins
    )
  }
  
  static func endpointsClosure<T>(_ xAccessToken: String? = nil) -> (T) -> Endpoint where T: TargetType {
    return { target in
      let endpoint = MoyaProvider.defaultEndpointMapping(for: target)
      return endpoint
    }
  }
  
  static func endpointResolver() -> MoyaProvider<T>.RequestClosure {
    return { (endpoint: Endpoint, closure: MoyaProvider<T>.RequestResultClosure) -> Void in
      if var urlRequest = try? endpoint.urlRequest() {
        urlRequest.timeoutInterval = 20
        closure(.success(urlRequest))
      } else {
        closure(.failure(MoyaError.requestMapping(endpoint.url)))
      }
    }
  }
}

extension NetworkManagerType {
  public func request(_ target: T) -> Single<Any> {
    return provider.request(target)
      .mapJSON()
      .observe(on: MainScheduler.instance)
      .asSingle()
  }
  
  public func requestMappingVoid(_ target: T) -> Single<Void> {
    return provider.request(target)
      .mapVoid()
      .asSingle()
  }
  
  public func requestWithoutMapping(_ target: T) -> Single<Moya.Response> {
    return provider.request(target)
      .observe(on: MainScheduler.instance)
      .asSingle()
  }
  
  public func requestObject<D: Decodable>(_ target: T, type: D.Type) -> Single<D> {
    return provider.request(target)
      .map(D.self)
      .observe(on: MainScheduler.instance)
      .asSingle()
  }
  
  public func requestDeepModel<D: Codable>(_ target: T, type: D.Type) -> Single<D> {
    return requestObject(target, type: ResponseModel<D>.self)
      .map { $0.data }
  }
  
  public func requestArray<D: Decodable>(_ target: T, type: D.Type) -> Single<[D]> {
    return provider.request(target)
      .map([D].self)
      .observe(on: MainScheduler.instance)
      .asSingle()
  }
}

extension ObservableType {
  func mapVoid() -> Observable<Void> {
    return map { _ in }
  }
}
