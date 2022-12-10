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
      if newValue == true && !isRefreshing {
        beginRefreshing()
      } else {
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

//extension Reactive where Base: MJRefreshFooter {
//    public var isNomoreData: Binder<Bool> {
//        return Binder(self.base) { refreshControl, nomoreData in
//            if nomoreData {
//                refreshControl.endRefreshingWithNoMoreData()
//            } else {
//                refreshControl.resetNoMoreData()
//            }
//        }
//    }
//}
