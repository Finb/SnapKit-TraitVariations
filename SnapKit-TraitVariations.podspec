Pod::Spec.new do |s|

  s.name = "SnapKit-TraitVariations"
  s.version = "0.0.1"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.summary = "A library to help you use Trait Variations with SnapKit"
  s.homepage = "https://github.com/Finb/SnapKit-TraitVariations"
  s.author = { "Fin" => "fin.uuid@gmail.com" }
  s.source = { :git => 'https://github.com/Finb/SnapKit-TraitVariations.git', :tag => s.version }

  s.ios.deployment_target = '8.0'

  s.requires_arc = 'true'
  s.source_files = 'SnapKit-TraitVariations/*.swift'
  s.dependency 'SnapKit', '~> 3.0.2'
  s.dependency 'Aspects', '~> 1.4.1'
end
