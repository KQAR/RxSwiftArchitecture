//
//  ProfileTableViewCell.swift
//  VIPER
//
//  Created by Jarvis on 2022/12/7.
//

import UIKit
import BaseView

class ProfileTableViewCell: TableViewCell {
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bind(to viewModel: ProfileTableViewCellViewModel) {
    
  }
}
