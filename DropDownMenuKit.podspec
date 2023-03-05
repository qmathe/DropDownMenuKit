Pod::Spec.new do |s|

  s.name         = "DropDownMenuKit"
  s.version      = "1.0"
  s.summary      = "UIKit drop down menu, simple yet flexible and written in Swift"
  s.description  = "DropDownMenuKit is a custom UIKit control to show a menu attached to the navigation bar or toolbar. The menu appears with a sliding animation and can be deeply customized. For example, with icons, embedded controls, or a checkmark to denote a selected row among multiple menu cells."
  s.homepage     = "https://github.com/qmathe/DropDownMenuKit"
  s.screenshots  = "http://www.quentinmathe.com/github/DropDownMenuKit/App%20History%20Menu%20-%20iPhone%205.png"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Quentin Mathé" => "quentin.mathe@gmail.com" }
  s.social_media_url   = "http://twitter.com/quentin_mathe"

  s.swift_version = "5.0"
  s.platform     = :ios, "11.0"

  s.source       = { :git => "https://github.com/qmathe/DropDownMenuKit.git", :tag => "1.0" }
  s.source_files = "*.swift", "*.{h,m}"
  s.public_header_files = "*.h"
  # Each xcassets directory must be in a distinct resource bundle (otherwise multiple assets.car end up in the same bundle) 
  s.resource_bundles    = { "DropDownMenuKitAssets" => ["DropDownMenuKit.xcassets"] }
end
