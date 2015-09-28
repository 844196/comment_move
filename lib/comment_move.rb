require "comment_move/version"
require "comment_move/login.rb"
require "comment_move/get_playerstatus.rb"
require "comment_move/get_waybackkey.rb"
require "time"

class NicovideoAccount
  include CommentMove
  attr_accessor :username, :password, :user_session

  def create_usersission
    @user_session = login(@username, @password)
  end
end

class NicovideoLiveBrodcast < NicovideoAccount
  def get_comment(lv)
    lv = lv
    playerstatus = get_playerstatus(lv, @user_session)
    waybackkey = get_waybackkey(playerstatus[:thread], @user_session)

    data = {
      thread: playerstatus[:thread],
      version: 20061206,
      res_from: -1000,
      waybackkey: waybackkey,
      user_id: playerstatus[:user]
    }

    comments = []
    TCPSocket.open(playerstatus[:addr], playerstatus[:port]) do |socket|
      req = "<thread #{data.map {|k,v| "#{k}=\"#{v}\"" }.join(' ')}/>\0"
      socket.write(req)

      loop do
        stream = socket.gets("\0")
        xml = Nokogiri::XML(stream)

        next if xml.xpath('//chat').empty?
        break if xml.text == '/disconnect' && xml.xpath('/chat').attr('premium').text == '2'

        h = xml.xpath('/chat').first.attributes.map{|k,v| [k.to_sym,v.text] }.to_h
        h.delete_if {|k,_| [:thread, :vpos, :date_usec, :locale, :name, :mail].include?(k) }

        h[:type] ||= nil
        h[:premium] ||= 0
        h[:anonymity] ||= false
        h[:comment] = xml.text.gsub(/[\r\n]/, '')

        h.each do |k,v|
          case k
          when :no
            h[k] = v.to_i
          when :anonymity
            h[k] = true if v == '1'
          when :date
            h[k] = Time.at(v.to_i)
          when :premium
            case v.to_i
            when 0
              h[k] = false
              h[:type] = 'user'
            when 1
              h[k] = true
              h[:type] = 'user'
            when 2
              h[k] = nil
              h[:type] = 'system'
            when 3
              h[k] = nil
              h[:type] = 'operator'
            end
          end
        end

        comments.push(h)
      end
    end
    comments
  end
end
