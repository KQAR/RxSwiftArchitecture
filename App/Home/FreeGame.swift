//
//  FreeGame.swift
//  VoltaEel
//
//  Created by Jarvis on 2023/10/24.
//

import Foundation

public struct FreeGame: Codable {
  let id: Int
  let title: String
  let thumbnail: String
  let short_description: String
  let game_url: String
  let genre: String
  let platform: String
  let publisher: String
  let developer: String
  let release_date: String
  let freetogame_profile_url: String
  
  var cover: URL? {
    return URL(string: thumbnail)
  }
}
