//
//  HomeModel.swift
//  VIPER
//
//  Created by 金瑞 on 2022/12/10.
//

import Foundation
import RxExtension

struct HomeModel: Codable, Paginable {
  let items: [HomeItem]
  let current: Int
  let pages: Int
}

extension HomeModel: DataStatusPresentable {
  var dataStatus: DataStatus {
    return items.isEmpty ? .empty : .normal
  }
}

struct HomeItem: Codable {
  var cover: String?
  var title: String?
  var content: String?
}
