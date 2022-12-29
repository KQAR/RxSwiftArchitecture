//
//  ProfileModel.swift
//  VoltaEel
//
//  Created by Jarvis on 2022/12/29.
//

import Foundation

struct ProfileModel: Codable {
  let userInfos: [UserInfo]
}

struct UserInfo: Codable {
  var username: String?
  var avatar: String?
  var address: String?
  var about: String?
}
