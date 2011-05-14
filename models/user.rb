class User
  include DataMapper::Resource
  
  property :id, Serial
  property :nickname, String, required: true
  property :email, String, length: 100, required: true
  property :password, String, length: 100
  property :salt, String, length: 100
  property :name, String, length: 100
  property :address, String, length: 100
  property :zip, String, length: 100
  property :city, String, length: 100
  property :country, String, length: 100
  property :phone, String, length: 100
  property :bio, Text
  
  def nick
    nickname
  end
end