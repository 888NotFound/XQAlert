Pod::Spec.new do |s|
    
    s.name         = "XQAlert"      #SDK名称
    s.version      = "0.1"#版本号
    s.homepage     = "https://github.com/SyKingW/XQProjectTool"  #工程主页地址
    s.summary      = "一些项目里面要用到的’小公举’."  #项目的简单描述
    s.license      = "MIT"  #协议类型
    s.author       = { "王兴乾" => "1034439685@qq.com" } #作者及联系方式
    s.ios.deployment_target  = "10.0" #平台及版本
    s.source       = { :git => "https://github.com/SyKingW/XQProjectTool.git" ,:tag => "#{s.version}"}   #工程地址及版本号
    s.requires_arc = true   #是否必须arc
    
    s.swift_version = '5.1'
    s.source_files = 'SDK/**/*.{h,m,swift}'
#    s.resources = 'SDK/**/*.{xib}'

    s.dependency 'Masonry'
    
    s.resources = 'SDK/**/*.{xib}'
        
end






