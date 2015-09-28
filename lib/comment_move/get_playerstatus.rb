require 'net/https'
require 'nokogiri'

module CommentMove
  def get_playerstatus(lv, user_session)
    url = Net::HTTP.new('watch.live.nicovideo.jp')
    res = url.get("/api/getplayerstatus?v=#{lv}", {'Cookie' => "user_session=#{user_session}"})
    xml = Nokogiri::XML(res.body)

    {
      user: xml.xpath('//user/user_id').text,
      addr: xml.xpath('//ms//addr').text,
      port: xml.xpath('//ms//port').text.to_i,
      thread: xml.xpath('//ms//thread').text
    }
  end
end
