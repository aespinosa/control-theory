module Plotter
  def f
    @f ||= File.open(name, 'w')
  end

  def teardown
    @f.close
  end
end
