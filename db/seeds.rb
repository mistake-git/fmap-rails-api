5.times.each do |i|
  Post.create(name: "test#{i + 1}")
end
