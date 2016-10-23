
Pod::Spec.new do |s|

  s.name         	= “XFAssistiveTouch”
  s.version      	= “0.0.1”
  s.summary      	= “Assistive button the same as iOS AssistiveTouch”
  s.homepage     	= "https://github.com/xiaofei86/XFAssistiveTouch"
  s.license      	= { :type => "MIT", :file => "LICENSE" }
  s.author 		= { "XuYafei" => "xuyafei86@163.com" }
  s.social_media_url   	= "http://xuyafei.cn"
  s.platform     	= :ios, “8.0”
  s.source       	= { :git => "https://github.com/xiaofei86/AssistiveTouch.git", :tag => s.version }
  s.source_files  	= "AssistiveTouch/*.{h,m}"
  s.requires_arc 	= true

end

