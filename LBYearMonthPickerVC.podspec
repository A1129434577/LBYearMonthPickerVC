Pod::Spec.new do |spec|
  spec.name         = "LBYearMonthPickerVC"
  spec.version      = "0.0.2"
  spec.summary      = "只能选择年月的时间选择器"
  spec.description  = "只显示年月，并且可以自定义参数加入到任何位置，比如【全部年】/【全部月】的时间选择器。"
  spec.homepage     = "https://github.com/A1129434577/LBYearMonthPickerVC"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "刘彬" => "1129434577@qq.com" }
  spec.platform     = :ios
  spec.ios.deployment_target = '8.0'
  spec.source       = { :git => 'https://github.com/A1129434577/LBYearMonthPickerVC.git', :tag => spec.version.to_s }
  spec.dependency     "LBPresentTransitions"
  spec.source_files = "LBYearMonthPickerVC/**/*.{h,m}"
  spec.requires_arc = true
end
#--use-libraries