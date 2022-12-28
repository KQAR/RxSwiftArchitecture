//
//  HomeRequestApi.swift
//  VIPER
//
//  Created by 金瑞 on 2022/12/10.
//

import Moya

enum HomeRequestApi {
  case homeInfo
  case bannerInfo
  case userTag
}

extension HomeRequestApi: TargetType {
  var path: String {
    switch self {
    case .homeInfo:
      return "/api/homeInfo"
    case .bannerInfo:
      return "/api/bannerInfo"
    case .userTag:
      return "/api/userTag"
    }
  }
  
  var parameters: [String : Any]? {
    return nil
  }
  
  var method: Method {
    return .post
  }
  
  var task: Task {
    return .requestPlain
  }
  
  var headers: [String : String]? {
    return nil
  }
  
  var sampleData: Data {
    let mock = R.file.homeMockJson()
    if let mock, let data = try? Data(contentsOf: mock) {
        return data
    }
    return "{}".data(using: .utf8)!
  }
}
