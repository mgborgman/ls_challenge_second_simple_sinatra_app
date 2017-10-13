require 'tilt/erubis'
require 'sinatra'
require 'sinatra/reloader'
require 'YAML'

def get_total_interests
  total = 0
  @names.each do |name|
    total += @content[name.to_sym][:interests].size  
  end
  total
end

before do
  @content = YAML.load_file('users.yaml')
  @names = @content.keys.map(&:to_s)
  @total_number_of_users = @names.size
  @total_number_of_interests = get_total_interests
end

get '/' do
  @title = "Users and Interests"
  erb :home
end

get '/:user' do
  user = params[:user]
  @other_users = @names.delete_if{|name, | name == user}
  @email = @content[user.to_sym][:email]
  @interests = @content[user.to_sym][:interests]
  @title = "#{user}'s Page"
  erb :user
end