platform :ios, '11.0'

inhibit_all_warnings!

def utils
    pod 'SwiftLint', '~> 0.30.1'
    pod 'SwiftGen', '~> 6.1.0'
end

def common_pods
    pod 'RxSwift', '~> 4.5.0'
    pod 'RxCocoa', '~> 4.5.0'
end

target 'mvvm' do
    use_frameworks!
    utils
    common_pods
    pod 'PinLayout', '~> 1.8.7'
end

target 'mvvmTests' do
  use_frameworks!
  common_pods
  pod 'RxTest', '~> 4.5.0'
  pod 'RxBlocking', '~> 4.5.0'
end
