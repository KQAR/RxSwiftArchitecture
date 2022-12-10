//
//  Host.swift
//  NetworkManager
//
//  Created by 金瑞 on 2022/12/10.
//

import Moya

struct Host: RawRepresentable {
    /// 测试地址
    static let test = Host(rawValue: "http://api.test.com")
    /// 本地机器地址
    static let local = Host(rawValue: "http://172.25.20.154:9200")
    /// 线上地址
    static let online = Host(rawValue: "https://api.product.com")
    
    let rawValue: String
}

extension Host {
    static var baseURL: String {
        #if DEBUG
        return Host.test.rawValue
        #else
        return Host.online.rawValue
        #endif
    }
}

extension TargetType {
    var baseURL: URL {
        return URL(string: Host.baseURL)!
    }
}
