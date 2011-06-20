class Creation
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, length: 100, required: true, unique: true
  property :name_url, String, length: 100, unique: true
  property :category, String, length: 100
  property :path, String, length: 255
  property :description, Text
  
  belongs_to :user
  property :user_id, Integer
  
  require 'voidtools/dm/paginable'
  include Voidtools::Paginable
  def self.per_page
    12
  end
  
  default_scope(:default).update( order: [:id.desc] )
  
  def link(format=nil)
    format = "#{format}s/" unless format.nil?
    "/creations/#{format}#{id}.png"
  end

  before :valid? do
    self.name_url = name.urlize
  end
  
  
end