require_relative 'sensor'

require 'minitest/autorun'

class IntegrationTest < Minitest::Test
  include ControlTheory

  def test_pods_test
    pods = Pods.new
    assert_equal 400, pods.cpu_request
  end
end
