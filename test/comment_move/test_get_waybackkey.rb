require 'comment_move/get_waybackkey'
require 'webmock'
require 'webmock/test_unit'

include CommentMove
include WebMock::API

class TestGetWaybackKey < Test::Unit::TestCase
  class << self
    def startup
      @@api_endpoint_regex = /watch\.live\.nicovideo\.jp\/api\/.*/
    end
  end

  def setup
    WebMock.reset!
  end

  test '存在するスレッド番号' do
    stub_request(:get, @@api_endpoint_regex).to_return(
      :status => 200,
      :body   => 'waybackkey=WAYBACKKEY'
    )
    assert_equal(
      CommentMove::get_waybackkey('12345678', 'user_session_XXXXXXXXXXXXXXXXX'),
      'WAYBACKKEY'
    )
  end

  test '存在しないスレッド番号' do
    stub_request(:get, @@api_endpoint_regex).to_return(
      :status => 200,
      :body   => 'waybackkey='
    )
    assert_raise(InvalidThreadNumber) do
      CommentMove::get_waybackkey('badthread', 'user_session_XXXXXXXXXXXXXXXXX')
    end
  end
end
