//
//  Rx+MJRefresh.swift
//  BaseView
//
//  Created by 金瑞 on 2022/12/10.
//

import Foundation
import MJRefresh
import RxSwift

extension MJRefreshComponent {
  var isAnimating: Bool {
    get { return isRefreshing }
    set {
      // 开始刷新会由下拉动作自动触发，这里只需要在网络请求结束后结束刷新即可
      if newValue == false && isRefreshing {
        endRefreshing()
      }
    }
  }
}

extension MJRefreshFooter {
  var noMoreData: Bool {
    get { return state == .noMoreData }
    set {
      if newValue == true {
        endRefreshingWithNoMoreData()
      } else {
        resetNoMoreData()
      }
    }
  }
}
