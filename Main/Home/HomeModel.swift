//
//  HomeModel.swift
//  VIPER
//
//  Created by 金瑞 on 2022/12/10.
//

import Foundation

struct HomeModel: Codable {
  let items: [HomeItem]
}

struct HomeItem: Codable {
  var cover: String?
  var title: String?
  var content: String?
}
