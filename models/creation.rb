class Creation
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, length: 100
  property :name_url, String, length: 100
  property :category, String, length: 100
  property :path, String, length: 255
  property :description, Text
  
  belongs_to :user
  
  def link
    "/creations/#{id}.png"
  end

  before :create do
    name_url = name.urlize
  end

end