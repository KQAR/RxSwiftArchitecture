//
//  AdDialog.swift
//  VIPER
//
//  Created by 金瑞 on 2022/12/12.
//

import UIKit
import Popups
import Utility
import RxSwift
import RxCocoa

class AdDialog: UIViewController, ViewControllerPresentable {
  
  enum Action: CustomStringConvertible, CaseIterable {
    case next
    case go
    
    var description: String {
      switch self {
      case .next:
        return "下一个"
      case .go:
        return "GO"
      }
    }
    
    var color: UIColor {
      return .black
    }
  }
  
  private let observer: AnyObserver<Action>
  
  private let disposeBag = DisposeBag()
  private let stackView = Init(UIStackView()) { stack in
    stack.spacing = 20
    stack.axis = .horizontal
    stack.alignment = .fill
    stack.distribution = .equalSpacing
  }
  
  private init(observer: AnyObserver<Action>) {
    self.observer = observer
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var makeContentSize: CGSize {
    return CGSize(width: 200, height: 200)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .yellow
    
    view.addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.bottom.equalToSuperview().inset(10)
      make.left.greaterThanOrEqualTo(10)
      make.centerX.equalToSuperview()
    }
    
    setupActions()
  }
  
  private func setupActions() {
    Action.allCases.forEach { action in
      let button = UIButton()
      button.setTitle(action.description, for: .normal)
      button.setTitleColor(action.color, for: .normal)
      stackView.addArrangedSubview(button)
      button.snp.makeConstraints { make in
        make.size.equalTo(CGSize(width: 60, height: 44))
      }
      button.rx.tap.asSignal()
        .withUnretained(self)
        .emit(onNext: { owner, _ in
          owner.observer.on(.next(action))
          owner.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
  }
  
  static func popupAction(in viewController: UIViewController, animated: Bool) -> Observable<Action> {
    Observable.create { observer in
      let dialog = AdDialog(observer: observer)
      dialog.popup(in: viewController, animated: animated)
      return Disposables.create {
        dialog.dismiss(animated: true)
      }
    }
  }
}
