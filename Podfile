inhibit_all_warnings!

platform:ios, '13.0'
use_frameworks!

## ==> Pods分组 <==

# 依赖注入
def injectionPods
  pod 'Factory'
end

# 视图库
def viewPods
  pod 'SnapKit'
  pod 'MJRefresh'
  pod 'EmptyDataSet-Swift'
  pod "ESTabBarController-swift"
end

# Rx
def rxPods
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
end

# 网络
def networkPods
  pod 'Alamofire'
  pod 'Moya/RxSwift'
end

# 图片库
def imagePods
  pod 'Kingfisher', '~> 7.0'
end

# Animation
def animationPods
  pod 'lottie-ios'
end

## ==> Target <==

# 主工程
target 'VoltaEel' do
  injectionPods
  imagePods
  viewPods
  rxPods
  pod 'R.swift'
end

# 认证模块
target 'Authentication' do
  injectionPods
end

# 基础视图库
target 'BaseView' do
  injectionPods
  animationPods
  viewPods
  rxPods
end

# 整体框架基础绑定
target 'Bindable' do
  rxPods
  networkPods
end

# Rx扩展库
target 'RxExtension' do
  rxPods
  imagePods
end

# 模块中介者
target 'Mediator' do
  injectionPods
end

# 网络模块
target 'NetworkManager' do
  networkPods
  rxPods
end
