

path = File.expand_path "../", __FILE__

require "#{path}/handsonxp"

User.create(nickname: "leovinci", email: "leovinci@gmail.com", name: "Leonardo Da Vinci", password: "leovinci")

Creation.create(name: "vite aerea", description: "ho sempre sognato di volare")