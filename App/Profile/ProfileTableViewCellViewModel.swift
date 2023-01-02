//
//  ProfileTableViewCellViewModel.swift
//  VIPER
//
//  Created by Jarvis on 2022/12/7.
//

import Foundation
import Bindable

class ProfileTableViewCellViewModel: IdentifiableViewModel {
  init(identity: UUID = UUID(), userInfo: UserInfo) {
    super.init(identity: identity)
  }
}
