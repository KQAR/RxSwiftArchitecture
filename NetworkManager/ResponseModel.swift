//
//  ResponseModel.swift
//  NetworkManager
//
//  Created by 金瑞 on 2022/12/10.
//

import Foundation

struct ResponseModel<Data: Codable>: Codable {
  let code: Int
  let data: Data
  let msg: String?
  let token: String?
}
