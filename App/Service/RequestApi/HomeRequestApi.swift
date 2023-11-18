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
  case detail(id: String)
  case gameList
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
    case .detail:
      return "/api/detail"
    case .gameList:
      return "/api/games"
    }
  }
  
  var parameters: [String : Any]? {
    return nil
  }
  
  var method: Method {
    return .get
  }
  
  var task: Task {
    return .requestPlain
  }
  
  var headers: [String : String]? {
    return nil
  }
  
  var sampleData: Data {
    var mock: URL?
    switch self {
    case .homeInfo:
      mock = R.file.homeMockJson()
    case .detail:
      mock = R.file.detailMockJson()
    default:
      mock = nil
    }
    if let mock, let data = try? Data(contentsOf: mock) {
        return data
    }
    return "{}".data(using: .utf8)!
  }
}
