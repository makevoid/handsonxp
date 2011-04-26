class Creation
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, length: 100
  property :category, String, length: 100
  property :path, String, length: 255
  property :description, Text
  
  def link
    "/creations/#{id}.png"
  end
end