module ViewHelpers
  
  def body_class
    path = request.path.split("/")[1..2]
    path = path.join(" ") unless path.nil?
    request.path == "/" ? "home" : path
  end
  
  
  # creation helpers
  
  def nophoto? creation, type=nil
    if File.exists? creation.path(type)
      creation.link type
    else
      "/imgs/no_photo.png"
    end
  end
  
end