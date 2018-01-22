# test.rb
require 'rest-client'
require 'nokogiri'
require_relative './secret.rb'

cookie    = COOKIE
url       = "https://fullstack.qzy.camp/posts/687"
response  = RestClient.get(url, {Cookie: cookie})
doc       = Nokogiri::HTML.parse(response.body)

# 分解html
them      = doc.css("h1")[0].to_s            # 大标题
chapt     = doc.css(".des-text h4").to_s     # 小标题
post      = doc.css(".post").to_s            # 主体内容
content   = them + chapt + post              # 组合

# 文件写入
file = File.new("page.erb", 'w')
file.write(content)

puts doc
