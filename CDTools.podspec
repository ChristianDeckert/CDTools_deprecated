Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '9.0'
s.name = "CDTools"
s.summary = "My swift 3 tool box."
s.requires_arc = true
s.version = "2.0.2"
#s.license = { :type => "MIT", :file => "CDTools/LICENSE" }
s.license      = {
:type => 'MIT',
:text => <<-LICENSE
Copyright (c) 2017 Christian Deckert

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
LICENSE
}

s.author = { "Christian Deckert" => "Christian.Deckert@icloud.com" }
s.homepage = "https://github.com/ChristianDeckert/CDTools"
s.source = { :git => "https://github.com/ChristianDeckert/CDTools.git", :branch => "feature/swift23" }
#s.source = { :git => "https://github.com/ChristianDeckert/CDTools.git", :branch => "master", :tag => "#{s.version}"}
#s.source = { :git => "https://github.com/ChristianDeckert/CDTools.git", :commit => "497d608e516c74259b7f49bffe1f9c1f68df44da" }

s.default_subspec = 'Default'

  s.subspec 'Default' do |ss|

    #ss.frameworks = 'UIKit', 'Foundation'
    ss.source_files = "CDTools/**/*.{swift}", "CDTools/Foundation/**/*.*", "CDTools/UI/**/*.*"
    ss.resource_bundles = {
      "CDToolsResources" => ["CDTools/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"]
    }

    #ss.resources = "CDTools/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
    #ss.dependency 'Alamofire'

  end

end
