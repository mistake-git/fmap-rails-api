10.times.each do |i|
  User.create(
    name: "test#{i + 1}",
    email: "test#{i + 1}@gmail.com",
    uid: "test#{i + 1}"
  )
end
