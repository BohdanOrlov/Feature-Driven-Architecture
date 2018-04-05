platform :ios, '11.2'
workspace 'BlogApp.xcworkspace'

target 'BlogApp' do
  use_frameworks!
  project 'BlogApp/BlogApp.xcodeproj'

  pod 'Layoutless'

  target 'BlogAppTests' do
    inherit! :search_paths
    pod 'Layoutless'
  end
end

target 'Features' do
    use_frameworks!
    project 'Features/Features.xcodeproj'
    pod 'Layoutless'
    
    target 'FeaturesTests' do
        inherit! :search_paths
        pod 'Layoutless'
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

#target 'Core' do
#    project 'Core/Core.xcodeproj'
#    
#    target 'CoreTestsSupport' do
#        inherit! :search_paths
#    end
#
#    target 'CoreTests' do
#        inherit! :search_paths
#    end
#end
