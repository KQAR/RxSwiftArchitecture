//
//  TableView.swift
//  BaseView
//
//  Created by Jarvis on 2022/12/6.
//

import UIKit

open class TableView: UITableView {
  
  enum Metrics {
    static let separatorColor = UIColor.gray
  }
  
  init () {
    super.init(frame: CGRect(), style: .grouped)
  }
  
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    makeUI()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    makeUI()
  }
  
  func makeUI() {
    rowHeight = UITableView.automaticDimension
    estimatedRowHeight = 50
    sectionHeaderHeight = 40
    backgroundColor = .clear
    cellLayoutMarginsFollowReadableWidth = false
    keyboardDismissMode = .onDrag
    separatorColor = Metrics.separatorColor
    separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    tableFooterView = UIView()
  }
}
