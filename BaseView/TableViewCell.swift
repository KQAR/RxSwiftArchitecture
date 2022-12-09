//
//  TableViewCell.swift
//  BaseView
//
//  Created by Jarvis on 2022/12/6.
//

import UIKit
import RxSwift

open class TableViewCell: UITableViewCell {
  open var disposeBag = DisposeBag()
}

public extension TableViewCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
