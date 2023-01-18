//
//  Detail.swift
//  VoltaEel
//
//  Created by Jarvis on 2022/12/30.
//

import Foundation

struct Detail: Codable {
  var id: String?
  var cover: String?
  var title: String?
  var content: String?
  var collection: Bool?
  
  var isCollect: String {
    return collection.or(false) ? "是否取消收藏" : "是否确认收藏"
  }
}
