//
//  Rx+MJRefresh.swift
//  BaseView
//
//  Created by 金瑞 on 2022/12/10.
//

import Foundation
import RxSwift
import MJRefresh

//extension Reactive where Base: KafkaFootRefreshControl {
//    public var isNomoreData: Binder<Bool> {
//        return Binder(self.base) { refreshControl, nomoreData in
//            if nomoreData {
//                refreshControl.endRefreshingAndNoLongerRefreshing(withAlertText: "")
//            } else if refreshControl.isShouldNoLongerRefresh {
//                refreshControl.resumeRefreshAvailable()
//            }
//        }
//    }
//}
extension MJRefreshComponent {
  var isAnimating: Bool {
    get { return isRefreshing }
    set {
      if newValue == true {
        beginRefreshing()
      } else {
        endRefreshing()
      }
    }
  }
}

//extension Reactive where Base: RefrshHeaderControl {
////  public
//}
