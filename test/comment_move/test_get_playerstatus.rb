require 'comment_move/get_playerstatus'
require 'webmock'
require 'webmock/test_unit'

include CommentMove
include WebMock::API

class TestGetPlayerStatus < Test::Unit::TestCase
  class << self
    def startup
      @@api_endpoint_regex = /watch\.live\.nicovideo\.jp\/api\/.*/
    end
  end

  def setup
    WebMock.reset!
  end

  test '存在する放送' do
    return_xml = build_xml_string do |xml|
      xml.getplayerstatus {
        xml.ms {
          xml.addr { xml.text 'msg000.live.nicovideo.jp' }
          xml.port { xml.text '1234' }
          xml.thread { xml.text '1234567890' }
        }
        xml.user {
          xml.user_id { xml.text '12345' }
        }
      }
    end
    stub_request(:get, @@api_endpoint_regex).to_return(:status => 200, :body => return_xml)
    assert_equal(
      CommentMove::get_playerstatus('lv00000000', 'user_session_XXXXXXXXXXXXXXXXX'),
      {
        :user   => '12345',
        :addr   => 'msg000.live.nicovideo.jp',
        :port   => 1234,
        :thread => '1234567890'
      }
    )
  end

  sub_test_case '異常系' do
    data do
      data_set = Hash.new {|h,k| h[k] = [] }
      test_case = {
        '存在するが、TS期限切れ（もしくはTS準備前）の放送' => ['closed', InvalidLiveVideoNumber],
        '存在しない放送' => ['notfound', InvalidLiveVideoNumber],
        'セッション有効期限切れ' => ['notlogin', ExpiredUserSession]
      }
      test_case.each_pair do |subject, set|
        code, exception = set
        data_set[subject] << build_xml_string do |xml|
          xml.getplayerstatus {
            xml.error {
              xml.code { xml.text code }
            }
          }
        end
        data_set[subject] << exception
      end
      data_set
    end

    test '例外処理' do |(return_xml, exception)|
      stub_request(:get, @@api_endpoint_regex).to_return(:status => 200, :body => return_xml)
      assert_raise(exception) do
        CommentMove::get_playerstatus('lv00000000', 'user_session_XXXXXXXXXXXXXXXXX')
      end
    end
  end
end
