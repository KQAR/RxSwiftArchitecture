//
//  ProfileRequestApi.swift
//  VoltaEel
//
//  Created by Jarvis on 2022/12/29.
//

import Moya

enum ProfileRequestApi {
  case userInfo
}

extension ProfileRequestApi: TargetType {
  var path: String {
    switch self {
    case .userInfo:
      return "/api/userInfo"
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
    let mock = R.file.profileMockJson()
    if let mock, let data = try? Data(contentsOf: mock) {
        return data
    }
    return "{}".data(using: .utf8)!
  }
}
