def source_paths
  Array(super) + [File.expand_path(File.dirname(__FILE__))]
end

def copy_and_replace(source, dest = nil)
  dest_file = dest.nil? ? source : dest
  copy_file(source, dest_file, force: true)
end

# GEMFILE
########################################
inject_into_file 'Gemfile', before: 'group :development, :test do' do
  <<~RUBY
    gem 'jwt'

  RUBY
end

inject_into_file 'Gemfile', after: 'group :development, :test do' do
  <<-RUBY

  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'dotenv-rails'
  RUBY
end

# JsonWebToken Class
########################################
# The reason we're creating the new class in app/lib rather than lib is that
# subdirectories under app are autoloaded by default.
run 'mkdir app/lib'
run 'touch app/lib/json_web_token.rb'

copy_and_replace 'app/lib/json_web_token.rb'

# Authorization Service
########################################
run 'mkdir app/services'
run 'touch app/services/authorization_service.rb'

copy_and_replace 'app/services/authorization_service.rb'

# Controllers
########################################
run 'touch app/controllers/concerns/secured.rb'
run 'touch app/controllers/private_controller.rb'
run 'touch app/controllers/public_controller.rb'

copy_and_replace 'app/controllers/concerns/secured.rb'
copy_and_replace 'app/controllers/private_controller.rb'
copy_and_replace 'app/controllers/public_controller.rb'

########################################
# AFTER BUNDLE
########################################
after_bundle do
  # Generators: db + simple form + pages controller
  ########################################
  rails_command 'db:drop db:create db:migrate'
  # generate('simple_form:install', '--bootstrap')
  # generate(:controller, 'pages', 'home', '--skip-routes', '--no-test-framework')

  # Routes
  ########################################
  # route "root to: 'pages#home'"
  route "get 'api/public', to: 'public#public'"
  route "get 'api/private', to: 'private#private'"
  route "get 'api/private-scoped', to: 'private#private_scoped'"

  # Git ignore
  ########################################
  append_file '.gitignore', <<~TXT
    # Ignore .env file containing credentials.
    .env*
    # Ignore Mac and Linux file system files
    *.swp
    .DS_Store
  TXT

  # Dotenv
  ########################################
  run 'touch .env'

  # Git
  ########################################
  git add: '.'
  git commit: "-m 'initial commit with Auth0 quickstarts files'"

  # Fix puma config
  # gsub_file('config/puma.rb', 'pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }', '# pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }')
end
