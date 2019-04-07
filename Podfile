platform :ios, '11.0'

inhibit_all_warnings!

def utils
    pod 'SwiftLint', '~> 0.30.1'
end

def common_pods
    utils

    pod 'RxSwift', '~> 4.5.0'
    pod 'RxCocoa', '~> 4.5.0'
end

target 'mvvm' do

    use_frameworks!

    common_pods
end
