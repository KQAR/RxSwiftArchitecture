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
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(contentView)
    contentView.addSubviews([coverImageView, titleLabel, contentLabel])
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
      make.left.right.equalToSuperview().inset(25)
    }
    contentLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(15)
      make.left.right.bottom.equalToSuperview().inset(25)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
