source 'https://rubygems.org'

gem 'rails', '3.2.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'activerecord-postgis-adapter' # Working with geodata
gem 'activerecord-postgres-hstore' # Working with hstore
gem 'activerecord-postgres-array' # Working with arrays
gem 'thinking-sphinx', '>= 2.0.10'

gem 'rgeo'
gem 'rgeo-geojson'

gem 'osm-import', :git => 'git://github.com/alno/osm-import.git' # :path => '/home/alno/Projects/Map/osm-import'

gem 'yajl-ruby'

gem 'ancestry'

gem 'haml-rails'
gem 'rabl'
gem 'active_attr'

gem 'whenever' # Cron tasks

gem 'unicorn' # Use unicorn as the app server

group :development do
  gem 'capistrano' # Deploy with Capistrano
  gem 'capistrano-unicorn'
end

group :rendering do
  gem 'ruby_mapnik', :git => 'git://github.com/alno/Ruby-Mapnik.git'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'jquery-rails'
  gem 'spine-rails'
  gem 'bootstrap-sass'
  gem 'i18n-js', :git => 'git://github.com/fnando/i18n-js.git'

  gem 'uglifier', '>= 1.0.3'
  gem 'therubyracer'
end

group :development, :test do
  gem 'ruby-debug' # To use debugger
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'
