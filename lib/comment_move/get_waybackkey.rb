require_relative 'exception'
require 'net/https'
require 'nokogiri'

module CommentMove
  def get_waybackkey(thread, user_session)
    url = Net::HTTP.new('watch.live.nicovideo.jp')
    res = url.get("/api/getwaybackkey?thread=#{thread}", {'Cookie' => "user_session=#{user_session}"})

    unless waybackkey = res.body[/waybackkey=(.+)/, 1]
      raise InvalidThreadNumber
    end

    waybackkey
  end
end
