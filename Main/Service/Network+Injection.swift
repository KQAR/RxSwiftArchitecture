//
//  Network+Injection.swift
//  VIPER
//
//  Created by 金瑞 on 2022/12/10.
//

import Factory
import NetworkManager

extension Container {
  /// 首页 网络请求Api
  static let homeRequestApi = Factory { NetworkManager<HomeRequestApi>.defaultNetworking() }
  static let homeRequestApi_stubbing = Factory { NetworkManager<HomeRequestApi>.stubbingNetworking() }
  /// 我的 网络请求Api
  static let profileRequestApi = Factory { NetworkManager<ProfileRequestApi>.defaultNetworking() }
  static let profileRequestApi_stubbing = Factory { NetworkManager<ProfileRequestApi>.stubbingNetworking() }
}
