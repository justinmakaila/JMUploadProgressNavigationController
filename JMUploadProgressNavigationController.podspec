Pod::Spec.new do |s|

  s.name         = "JMUploadProgressNavigationController"
  s.version      = "0.0.1"
  s.summary      = "UINavigationController subclass that includes methods to show/hide an upload progress bar from the navigation bar"

  s.description  = <<-DESC
                   A longer description of JMUploadProgressNavigationBar in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/justinmakaila/JMUploadProgressNavigationBar"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }


  s.author       = { "justinmakaila" => "justinmakaila@gmail.com" }

  s.platform = :ios, '7.0'

  s.source       = { :git => "https://github.com/justinmakaila/JMUploadProgressNavigationBar.git", :commit => "1424e97412fdccd794f308585d6f6978f861d504" }


  s.source_files  = 'Classes', 'JMUploadProgressViewController/**/*.{h,m}'
  s.exclude_files = 'Classes/Exclude'
  s.dependency 'FXBlurView', '~>1.4.4'
end
