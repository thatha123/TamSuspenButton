Pod::Spec.new do |s|
    s.name          =  'TamSuspenButton'
    s.version       =  '1.0.0'
    s.summary       =  'A click button on the suspension window'
    s.homepage      =  'https://github.com/thatha123/TamSuspenButton'
    s.license       =  'MIT'
    s.authors       = {'Tam' => '1558842407@qq.com'}
    s.platform      =  :ios,'8.0'
    s.source        = {:git => 'https://github.com/thatha123/TamSuspenButton.git',:tag => "v#{s.version}" }
    s.source_files  =  'TamSuspenButtonDemo/TamSuspenButton/*.{h,m}'
    s.resource      =  'TamSuspenButtonDemo/TamSuspenButton/Resources'
    s.requires_arc  =  true
end
