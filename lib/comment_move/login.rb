require 'net/https'

module CommentMove
  def login(mail, password)
    https = Net::HTTP.new('secure.nicovideo.jp', 443)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response = https.start do |https|
      https.post('/secure/login?site=niconico', "mail=#{mail}&password=#{password}")
    end

    user_session = nil
    response.get_fields('set-cookie').each do |cookie|
      cookie.split('; ').each do |param|
        pair = param.split('=')
        if pair[0] == 'user_session'
          user_session = pair[1] unless pair[1] == 'deleted'
          break
        end
      end
      break unless user_session.nil?
    end
    user_session
  end
end
