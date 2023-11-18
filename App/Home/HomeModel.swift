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

public struct HomeItem: Codable {
  var id: String
  var cover: String?
  var title: String?
  var content: String?
  var beloved: Bool?
  
  var belovedState: Bool {
    return beloved ?? false
  }
  
  var coverUrl: URL? {
    guard let cover else {
      return nil
    }
    return URL(string: cover)
  }
  
  mutating func updateLoved() {
    guard beloved != nil else {
      beloved = true
      return
    }
    beloved?.toggle()
  }
}
