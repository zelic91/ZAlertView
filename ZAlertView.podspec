Pod::Spec.new do |s|
  s.name             = "ZAlertView"
  s.version          = "0.3.1"
  s.summary          = "A customizable AlertView written in Swift."
  s.description      = <<-DESC
A customizable AlertView written in Swift as a present for my 26th birthday. Of course, current libraries don't fit my need, so I have to rewrite one for later extensibility.
                       DESC

  s.homepage         = "https://github.com/zelic91/ZAlertView"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Thuong Nguyen" => "thuongnh.uit@gmail.com" }
  s.source           = { :git => "https://github.com/zelic91/ZAlertView.git", :tag => s.version.to_s }
  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
end
