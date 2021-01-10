20.times.each do |i|
  User.create(
    name: "test#{i + 11}",
    email: "test#{i + 11}@gmail.com",
    uid: "test#{i + 11}"
  )
end
