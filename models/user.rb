class User
  include DataMapper::Resource
  
  property :id, Serial
  property :nickname, String, required: true
  property :nick_url, String, required: true
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
  
  has n, :creations
  
  
  before :valid? do
    self.nick_url = nick.urlize
  end
  
  def nick
    nickname
  end
  
  # Auth
  
  require 'digest/sha2'
  
  before :create do
    generate_salt
    puts self.password
    self.password = generate_pass self.password
    puts self.password
  end
  
  def authorized?(pass)
    self.password == generate_pass(pass)
  end
  
  def generate_pass(pass)
    Digest::SHA2.hexdigest("#{pass}_-lol-_#{self.salt}")
  end
  
  def generate_salt
    self.salt = Digest::SHA2.hexdigest(Time.now.to_i.to_s + "lol")
  end
  
end