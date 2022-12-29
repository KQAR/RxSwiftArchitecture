//
//  HomeCollectionCell.swift
//  VIPER
//
//  Created by Jarvis on 2022/12/7.
//

import UIKit
import RxSwift
import BaseView
import Utility

class HomeCollectionCell: CollectionViewCell {
  
  var imageView = Init(UIImageView()) { imageView in
    imageView.layer.cornerRadius = 8
    imageView.layer.masksToBounds = true
    imageView.contentMode = .scaleAspectFill
  }
  
  var titleLabel = Init(UILabel()) { label in
    label.textColor = UIColor.white
    label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
  }
  
  var contentLabel = Init(UILabel()) { label in
    label.numberOfLines = 0
    label.textColor = UIColor.white
    label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.layer.cornerRadius = 5
    contentView.backgroundColor = UIColor.RGBA(r: 2, g: 17, b: 29, a: 1.0)
    
    contentView.addSubviews([imageView, titleLabel, contentLabel])
    imageView.snp.makeConstraints { make in
      make.left.top.bottom.equalToSuperview().inset(12)
      make.width.equalTo(imageView.snp.height)
    }
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView)
      make.left.equalTo(imageView.snp.right).offset(15)
      make.right.lessThanOrEqualTo(-15)
    }
    contentLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.left.equalTo(titleLabel)
      make.right.lessThanOrEqualTo(-15)
      make.bottom.equalTo(imageView)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bind(to viewModel: HomeCollectionCellViewModel) {
    disposeBag = DisposeBag()
    viewModel.cover.drive(imageView.kf.rx.imageURL()).disposed(by: disposeBag)
    viewModel.title.drive(titleLabel.rx.text).disposed(by: disposeBag)
    viewModel.content.drive(contentLabel.rx.text).disposed(by: disposeBag)
  }
}
