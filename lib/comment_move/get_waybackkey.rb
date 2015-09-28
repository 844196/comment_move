require 'net/https'
require 'nokogiri'

module CommentMove
  def get_waybackkey(thread, user_session)
    url = Net::HTTP.new('watch.live.nicovideo.jp')
    res = url.get("/api/getwaybackkey?thread=#{thread}", {'Cookie' => "user_session=#{user_session}"})
    res.body[/waybackkey=(.+)/, 1]
  end
end
