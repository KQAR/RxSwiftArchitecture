//
//  Network+Injection.swift
//  VIPER
//
//  Created by 金瑞 on 2022/12/10.
//

import Factory
import NetworkManager

extension Container {
  static let homeRequestApi = Factory { NetworkManager<HomeRequestApi>.defaultNetworking() }
  static let homeRequestApi_stubbing = Factory { return NetworkManager<HomeRequestApi>.stubbingNetworking() }
}
