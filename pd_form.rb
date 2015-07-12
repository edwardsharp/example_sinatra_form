require 'rubygems'
require 'sinatra'
#require 'sinatra_more' # glob all sinatra_more 
require 'sinatra_more/markup_plugin' # or require 'sinatra_more/markup_plugin' for precise inclusion
require 'haml'
#require 'datamapper'
require 'dm-core'
require 'dm-timestamps'
# require 'dm-postgres-adapter'
require 'dm-sqlite-adapter'
require 'dm-migrations'
require 'pony'

SEND_TO = 'hello@lacuna.club'
Pony.options = {
  :via => :smtp,
  :via_options => {
    :address => 'smtp.sendgrid.net',
    :port => '587',
    :domain => 'lacuna.club',
    :user_name => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD'],
    :authentication => :plain,
    :enable_starttls_auto => true
  }
}

DataMapper::Logger.new($stdout, :debug)
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/pd_form.sqlite")
# DataMapper::setup(:default, ENV['DATABASE_URL'])

class PdResponseForm
  include DataMapper::Resource
  property :id, Serial
  property :created_at, DateTime
  property :updated_at, DateTime

  property :name, Text, :required => true, :default => 'NULL'
  property :email, Text, :required => true, :default => 'NULL'
  property :topicz, Text, :required => true, :default => 'NULL'
  property :datez, Text, :default => 'NULL'
  property :specificdatez, Text, :default => 'NULL'
  property :newtopd, Text, :default => 'NULL'
  property :other, Text, :default => 'NULL'
 
end

# perform basic sanity checks and initialize all relationships
# call this once you've defined all your models...
DataMapper.finalize

# create the table
#PdResponseForm.auto_migrate! 
#drop & recreate db
PdResponseForm.auto_upgrade!


configure do
	enable :dump_errors
	enable :logging
end

get '/' do
  
  haml :index
end

get '/success' do
	"success!"
end

post '/' do
  # params.each do |y|
  #   p y
  # end
	@results = PdResponseForm.new params
  @results.created_at = Time.now
  @results.updated_at = Time.now

  if @results.save
    Pony.mail :to => SEND_TO,
        :from => 'pd_form@lacuna.club',
        :subject => 'Pd_form',
        :body => "#{params.inspect}"

    "thank you!"
  else
    "fail! #{@results.errors.to_s}"
  end
  
	#haml :index
	#redirect "/success"
end

