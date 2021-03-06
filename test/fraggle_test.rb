require 'fraggle'

class FraggleTest < Test::Unit::TestCase

  def test_uri
    uri = "doozer:?ca=1:1&ca=2:2&ca=3:3&ignore=this&sk=foo"
    addrs, sk = Fraggle.uri(uri)
    assert_equal ["1:1", "2:2", "3:3"], addrs
    assert_equal "foo", sk
  end

end
