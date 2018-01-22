require 'rest-client'
require 'nokogiri'
require_relative 'secret.rb'
require_relative 'style.rb'

style = STYLE

# 获取开始页面的编码 和文件名
print "==================请输入一个开始页面的post编号："
start_page = gets.chomp

print "==================请输入保存的文件名："
file_name  = gets.chomp

# 结束画面
page_end = "<div class='end'>
              <a href='https://fullstack.qzy.camp/'>
                <img src='https://img.buzzfeed.com/buzzfeed-static/static/2014-10/26/6/enhanced/webdr08/longform-original-14836-1414320930-10.jpg'>
              </a>
              <p>The End</p>
            </div>"

# 写入样式
file = File.new("#{file_name}.html", 'w')
file.write(style)

# 基础链接
basic_url = 'https://fullstack.qzy.camp'
url       = basic_url + '/posts/' + start_page
cookie    = COOKIE

puts "===================已开始抓取数据：请耐心等候"
while (url != 'end')
  # 请求数据
  response = RestClient.get url, {Cookie: cookie}
  doc      = Nokogiri::HTML.parse(response.body)

  # 当post存在时，解析
  if !doc.css(".post").to_s.empty?
    title              = doc.css(".post-title-h1.markdown h1").to_s
    chapt              = doc.css(".des-text h4").to_s + '<hr>'
    post               = doc.css(".post").to_s
    content            = title + chapt + post
    page               = "<div class='frame'>#{content}</div>"

    # 写入本page数据
    file.write(page)
    puts "#{url}============中数据已成功抓取"

    # 计算下一个请求url
    next_relative_path = doc.css("li.next a")[0]['href'].to_s

    # 如果解析出来是 /dashboard 则代表本课结束
    url = (next_relative_path == '/dashboard') ? 'end' : (basic_url + next_relative_path)
  end
end

file.write(page_end)

puts "================本课数据已全部抓取 😊"
