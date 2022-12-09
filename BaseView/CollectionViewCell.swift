//
//  CollectionViewCell.swift
//  BaseView
//
//  Created by Jarvis on 2022/12/7.
//

import UIKit
import RxSwift

open class CollectionViewCell: UICollectionViewCell {
    open var disposeBag = DisposeBag()
}

public extension CollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
