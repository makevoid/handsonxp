require 'mini_magick'

path = File.expand_path "../../", __FILE__

imgs = Dir.glob("#{path}/public/creations/*.png")



def resize_and_crop(image, size)
  if image[:width] < image[:height]
    remove = ((image[:height] - image[:width])/2).round
    image.shave("0x#{remove}")
  elsif image[:width] > image[:height]
    remove = ((image[:width] - image[:height])/2).round
    image.shave("#{remove}x0")
  end
  image.resize("#{size}x#{size}")
  return image
end

imgs.each do |file|

  image = MiniMagick::Image.open(file)
  resize_and_crop(image, 220)
  pth = "#{path}/public/creations/thumbs/#{File.basename(file)}"
  image.write pth
  
end