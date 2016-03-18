Pod::Spec.new do |s|

  s.name         = "LPDebug"
  s.version      = "1.0.0"
  s.summary      = "Debug tool base on LPAssistiveTouch"
  s.homepage     = "https://github.com/xiaofei86/LPDebug"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "XuYafei" => "xuyafei86@163.com" }
  s.social_media_url   = "http://xuyafei.cn"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/xiaofei86/LPDebug.git", :tag => s.version }
  s.source_files = "LPDebug/**/*.{h,m}"
  s.resources    = "LPDebug/Images/*.png"
  s.requires_arc = true

end

