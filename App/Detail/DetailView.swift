//
//  DetailView.swift
//  VoltaEel
//
//  Created by Jarvis on 2022/12/30.
//

import UIKit
import RxSwift
import RxCocoa
import Utility

final class DetailView: UIScrollView {
  
  // public Observable
  
  var collect: Observable<Void> {
    return collectButton.rx.tap
      .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
  }
  
  // Public Observer
  
  var cover: Binder<URL?> {
    return coverImageView.kf.rx.imageURL()
  }
  
  var title: Binder<String?> {
    return titleLabel.rx.text
  }
  
  var content: Binder<String?> {
    return contentLabel.rx.text
  }
  
  var collectButtonHidden: Binder<Bool> {
    return collectButton.rx.isHidden
  }
  
  var collectButtonIsSelected: Binder<Bool> {
    return collectButton.rx.isSelected
  }
  
  // Private Property
  
  private let contentView = UIView()
  
  private let coverImageView = Init(UIImageView()) { imageView in
    imageView.layer.masksToBounds = true
    imageView.contentMode = .scaleAspectFill
  }
  
  private let titleLabel = Init(UILabel()) { label in
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
  }
  
  private let contentLabel = Init(UILabel()) { label in
    label.numberOfLines = 0
    label.textColor = .darkText
    label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
  }
  
  private let collectButton = Init(UIButton()) { button in
    button.setTitle("收藏", for: .normal)
    button.setTitle("已收藏", for: .selected)
    button.setTitleColor(.black, for: .normal)
    button.setBackgroundImage(UIImage(color: .lightGray), for: .normal)
    button.setBackgroundImage(UIImage(color: .yellow), for: .selected)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    button.layer.cornerRadius = 5
    button.layer.masksToBounds = true
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(contentView)
    contentView.addSubviews([coverImageView, titleLabel, contentLabel, collectButton])
    contentView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.width.equalToSuperview()
    }
    coverImageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.width.equalToSuperview()
      make.centerX.equalToSuperview()
    }
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(coverImageView.snp.bottom).offset(15)
      make.left.equalToSuperview().inset(25)
    }
    contentLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(15)
      make.left.right.bottom.equalToSuperview().inset(25)
    }
    collectButton.snp.makeConstraints { make in
      make.right.equalTo(-20)
      make.left.equalTo(titleLabel.snp.right).offset(20)
      make.centerY.equalTo(titleLabel)
      make.size.equalTo(CGSize(width: 45, height: 30))
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
