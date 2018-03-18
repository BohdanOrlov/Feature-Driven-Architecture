platform :ios, '11.2'
workspace 'BlogApp.xcworkspace'

target 'BlogApp' do
  use_frameworks!
  project 'BlogApp/BlogApp.xcodeproj'

  pod 'Layoutless'

  target 'BlogAppTestsSupport' do
    inherit! :search_paths
  end

  target 'BlogAppTests' do
    inherit! :search_paths
  end
end

target 'UI' do
  use_frameworks!
  project 'UI/UI.xcodeproj'
  pod 'Layoutless'

  target 'UITestsSupport' do
      inherit! :search_paths
  end
  
  target 'UITests' do
      inherit! :search_paths
  end
end

#target 'Domain' do
#    project 'Domain/Domain.xcodeproj'
#    
#    target 'DomainTestsSupport' do
#        inherit! :search_paths
#    end
#    
#    target 'DomainTests' do
#        inherit! :search_paths
#    end
#end

#target 'Platform' do
#    project 'Platform/Platform.xcodeproj'
#    
#    target 'PlatformTestsSupport' do
#        inherit! :search_paths
#    end
#
#    target 'PlatformTests' do
#        inherit! :search_paths
#    end
#end
