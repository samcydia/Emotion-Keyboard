Pod::Spec.new do |s|
  s.name         = "HMEmoticon"
  s.version      = "1.0.3"
  s.summary      = "仿新浪微博表情键盘"
  s.homepage     = "https://github.com/itheima-developer/HMEmoticon"
  s.license      = "MIT"
  s.author       =  { "Fan Liu" => "liufan321@gamil.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/itheima-developer/HMEmoticon.git", :tag => "#{s.version}" }
  s.source_files = "表情键盘/Emoticon/*.{h,m}"
  s.resources    = "表情键盘/Emoticon/HMEmoticon.bundle"
  s.requires_arc = true
end
