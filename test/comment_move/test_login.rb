require 'comment_move/login'
require 'webmock'
require 'webmock/test_unit'

include CommentMove
include WebMock::API

class TestLogin < Test::Unit::TestCase
  class << self
    def startup
      @@login_url_regex = /secure\.nicovideo\.jp.*/
    end
  end

  def setup
    WebMock.reset!
  end

  test '存在するユーザ情報' do
    stub_request(:post, @@login_url_regex).to_return(
      :status => 302,
      :headers => {'set-cookie' => 'user_session=user_session_hogefuga'}
    )

    @user_session = CommentMove::login('foo', 'bar')
    assert_equal('user_session_hogefuga', @user_session)
  end

  test '存在しないユーザ情報' do
    stub_request(:post, @@login_url_regex).to_return(
      :status => 302,
      :headers => {'set-cookie' => ''}
    )

    @user_session = CommentMove::login('foo', 'bar')
    assert_nil(@user_session)
  end

  test 'ネットワークエラー' do
    stub_request(:post, @@login_url_regex).to_return(:status => 404)

    assert_raise(NetworkError) { CommentMove::login('foo', 'bar') }
  end
end
