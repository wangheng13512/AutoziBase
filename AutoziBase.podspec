#
#  Be sure to run `pod spec lint AutoziBase.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "AutoziBase"
  s.version      = "0.0.1"
  s.summary      = "A short description of AutoziBase."

  s.homepage     = "https://github.com/wangheng13512/AutoziBase"
  s.author             = { "wangheng13512" => "1066026709@qq.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/wangheng13512/AutoziBase.git", :tag => "#{s.version}" }

#s.source_files  = "AutoziBase/**/*.{h,m,mm}"

  s.source_files  = "Base", "Category"
  s.dependency 'Alamofire', '~> 4.0.1'
  s.dependency 'SnapKit', '~> 3.0.2'
  s.dependency 'SVProgressHUD', '~> 2.0.3'
  s.dependency 'SwiftyJSON', '~> 3.1.1'
  s.dependency 'Kingfisher', '~> 3.2.0'

end
