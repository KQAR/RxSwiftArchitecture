//
//  ProfileModel.swift
//  VoltaEel
//
//  Created by Jarvis on 2022/12/29.
//

import Foundation
import RxExtension

struct ProfileModel: Codable, Paginable {
  let userInfos: [UserInfo]
  let current: Int
  let pages: Int
}

extension ProfileModel: DataStatusPresentable {
  var dataStatus: DataStatus {
    return userInfos.isEmpty ? .empty : .normal
  }
}

struct UserInfo: Codable {
  var username: String?
  var avatar: String?
  var address: String?
  var about: String?
}
