//
//  RefreshControl.swift
//  BaseView
//
//  Created by 金瑞 on 2022/12/10.
//

import Foundation
import MJRefresh

/// 下拉自动刷新控件
public class RefreshHeaderControl: MJRefreshNormalHeader {

}

/// 上拉自动加载控件
/// 隐藏了菊花和文字，上拉到控件全部显示时自动加载更多
public class RefreshFooterControl: MJRefreshAutoNormalFooter {
  public override func prepare() {
    super.prepare()
    stateLabel?.isHidden = true
  }
}
