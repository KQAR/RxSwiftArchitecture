//
//  HomeCollectionCell.swift
//  VIPER
//
//  Created by Jarvis on 2022/12/7.
//

import UIKit
import BaseView

class HomeCollectionCell: CollectionViewCell {
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .purple
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bind(to viewModel: HomeCollectionCellViewModel) {
    
  }
}
