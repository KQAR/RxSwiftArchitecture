//
//  ViewModelType.swift
//  Bindable
//
//  Created by Jarvis on 2022/12/7.
//

import Foundation
import NetworkManager
import RxExtension
import RxSwift
import Moya
import Log

public protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

open class ViewModel {
    
    public var pageSize = 10
    
    public let disposeBag = DisposeBag()
    
    public let pagingIndicator = PagingIndicator()

    public let loading = ActivityIndicator()
    public let headerLoading = ActivityIndicator()
    public let footerLoading = ActivityIndicator()

    public let error = ErrorTracker()
    public let serverError = PublishSubject<Error>()
    public let parsedError = PublishSubject<ApiError>()
    
    public init() {
        error.asObservable().bind(to: serverError).disposed(by: disposeBag)
        
        serverError.asObservable().map { (error) -> ApiError? in
            func dicMap(_ res: Response) -> [String: Any] {
                do {
                    let json = try res.mapJSON() as? [String: Any]
                    return json ?? [:]
                } catch {
                    printLog(error)
                    return [:]
                }
            }
            guard let moyaError = error as? MoyaError else { return nil }
            switch moyaError {
            case .imageMapping(let response):
                return ApiError.imageMapping(res: dicMap(response))
            case .jsonMapping(let response):
                return ApiError.jsonMapping(res: dicMap(response))
            case .stringMapping(let response):
                return .stringMapping(res: dicMap(response))
            case .objectMapping(let error, let response):
                return .objectMapping(error: error, res: dicMap(response))
            case .encodableMapping(let error):
                return .encodableMapping(error)
            case .underlying(let error, _):
                return .underlying(error)
            case .requestMapping(let string):
                return .requestMapping(string)
            case .parameterEncoding(let error):
                return .parameterEncoding(error)
            case .statusCode(let response):
                let msg = dicMap(response)["msg"] as? String
                return .statusCode(msg)
            }
        }.compactMap { $0 }.bind(to: parsedError).disposed(by: disposeBag)

        parsedError.subscribe(onNext: { (error) in
          printLog("\(error)")
        }).disposed(by: disposeBag)
    }
    
    deinit {
      printLog("\(type(of: self)): deinit")
    }
}
