Pod::Spec.new do |s|

# 1
s.platform = :ios
s.name = "CDTools"
s.summary = "My swift tool box."
s.requires_arc = true
s.version = "1.0"
s.license = { :type => "MIT", :file => "LICENSE" }
s.author = { "Christian Deckert" => "Christian.Deckert@icloud.com" }
s.homepage = "https://github.com/ChristianDeckert/CDTools"
s.source = { :git => "https://github.com/ChristianDeckert/CDTools.git", :tag => "#{s.version}"}
#s.source = { :git => "https://github.com/ChristianDeckert/CDTools.git", :commit => "d673f6f1f0aaffd0c1c8061eb1cdec1b1db34cd0" }

s.resource_bundles = {
'XRCoreResources' => ['Pod/Assets/*.png']
}

s.default_subspec = 'Default'

s.subspec 'Default' do |ss|

ss.framework = "UIKit"
ss.ios.deployment_target = '9.0'
ss.source_files = "CDTools/**/*.{swift}"
ss.resources = "CDTools/**/*.{png,jpeg,jpg,storyboard,xib}"
#ss.dependency 'Alamofire'

end

end