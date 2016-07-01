class App
  def call(env)
    100.times { Math.sqrt rand }
    body = ["Hello World! ", Math.sqrt(rand).to_s]
    [200, {"Content-Type" => "text/html"}, body ]
  end
end

run App.new
