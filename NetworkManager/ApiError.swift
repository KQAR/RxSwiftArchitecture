//
//  ApiError.swift
//  NetworkManager
//
//  Created by Jarvis on 2022/12/7.
//

import Foundation

public enum ApiError: Error {
    case imageMapping(res: [String: Any])
    case jsonMapping(res: [String: Any])
    case stringMapping(res: [String: Any])
    case objectMapping(error: Error, res: [String: Any])
    case encodableMapping(Error)
    case underlying(Error)
    case requestMapping(String)
    case parameterEncoding(Error)
    case statusCode(String?)
    
    var title: String {
        switch self {
        case .imageMapping:
            return "image解析错误"
        case .jsonMapping:
            return "json解析错误"
        case .stringMapping:
            return "string解析错误"
        case .objectMapping(_, let res):
            if let msg = res["msg"] as? String {
                return msg
            } else {
                return "对象解析错误"
            }
        case .encodableMapping:
            return "编码错误"
        case .underlying:
            return "网络请求错误"
        case .requestMapping:
            return "请求解析错误"
        case .parameterEncoding:
            return "参数编码错误"
        case .statusCode:
            return "服务器异常"
        }
    }
}
