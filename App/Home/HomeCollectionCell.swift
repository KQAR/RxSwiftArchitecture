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
import ReactorKit

final class HomeCollectionCell: CollectionViewCell, View {
  
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
  
  var loveButton = Init(UIButton()) { button in
    button.setTitle("💙", for: .normal)
    button.setTitle("❤️", for: .selected)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.layer.cornerRadius = 5
    contentView.backgroundColor = UIColor.RGBA(r: 2, g: 17, b: 29, a: 1.0)
    
    contentView.addSubviews([imageView, titleLabel, contentLabel, loveButton])
    imageView.snp.makeConstraints { make in
      make.left.top.bottom.equalToSuperview().inset(12)
      make.width.equalTo(imageView.snp.height)
    }
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView)
      make.left.equalTo(imageView.snp.right).offset(15)
      make.right.lessThanOrEqualTo(loveButton.snp.left).offset(-10)
    }
    contentLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.left.equalTo(titleLabel)
      make.right.lessThanOrEqualTo(-15)
      make.bottom.equalTo(imageView)
    }
    loveButton.snp.makeConstraints { make in
      make.right.equalTo(-15)
      make.centerY.equalTo(titleLabel)
      make.size.equalTo(30)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bind(reactor: HomeCollectionCellReactor) {
    disposeBag = DisposeBag()
    reactor.state.map(\.freeGame.cover).bind(to: imageView.kf.rx.imageURL()).disposed(by: disposeBag)
    reactor.state.map(\.freeGame.title).bind(to: titleLabel.rx.text).disposed(by: disposeBag)
    reactor.state.map(\.freeGame.short_description).bind(to: contentLabel.rx.text).disposed(by: disposeBag)
//    reactor.state.map(\.homeItem.belovedState).bind(to: loveButton.rx.isSelected).disposed(by: disposeBag)
    
    loveButton.rx.tap.map { Reactor.Action.likeTap }.bind(to: reactor.action).disposed(by: disposeBag)
  }
}
