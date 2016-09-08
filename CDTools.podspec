Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '9.0'
s.name = "CDTools"
s.summary = "My swift tool box."
s.requires_arc = true
s.version = "1.0"
s.license = { :type => "MIT", :file => "CDTools/LICENSE" }
s.author = { "Christian Deckert" => "Christian.Deckert@icloud.com" }
s.homepage = "https://github.com/ChristianDeckert/CDTools"
s.source = { :git => "https://github.com/ChristianDeckert/CDTools.git", :tag => "#{s.version}"}
#s.source = { :git => "https://github.com/ChristianDeckert/CDTools.git", :commit => "d673f6f1f0aaffd0c1c8061eb1cdec1b1db34cd0" }

s.default_subspec = 'Default'

s.subspec 'Default' do |ss|

ss.framework = "UIKit"
ss.framework = "Foundation"

ss.source_files = "CDTools/**/*.{swift}"
ss.resource_bundles = {
"CDToolsResources" => ["CDTools/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"]
}

#ss.resources = "CDTools/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
#ss.dependency 'Alamofire'

end

end