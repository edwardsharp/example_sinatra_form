# example_sinatra_form

A really simple HTML form rendered using HAML templates from a sinatra server using a postgres adapter. Emails results via the pony gem.

### FEATURES: 

* sinatra
* datamapper
* postgres
* haml
* pony

### REQUIREMENTS:

    gem install sinatra sinatra_more haml datamapper dm-core dm-timestamps dm-postgres-adapter dm-migrations pony --no-ri --no-rdoc

or use bundler:

    bundle install 

### USAGE

1. cd /path/to/example_sinatra_form

2. bundle exec ruby pd_form.rb 
