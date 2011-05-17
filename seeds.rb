

path = File.expand_path "../", __FILE__

require "#{path}/handsonxp"

u = User.new(nickname: "leovinci", email: "leovinci@gmail.com", name: "Leonardo Da Vinci", password: "leovinci")
u.save

p u.errors.inspect

u.creations.create(name: "vite aerea", description: "ho sempre sognato di volare")