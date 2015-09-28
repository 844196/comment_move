# CommentMove

## Usage

```ruby
require 'comment_move'

lv = NicovideoLiveBrodcast.new.tap do |niconico|
  niconico.username = 'hogefuga@844196.com'
  niconico.password = 'password'
  niconico.create_usersission
end

comment = lv.get_comment 'lv844196'
# => [{:no=>1, :date=>2015-09-28 00:22:02 +0900, :user_id=>"507820", :premium=>true, :type=>"user", :anonymity=>false, :comment=>"540円払ってよくこんな放送できるな"}, ...
```
