# config valid only for Capistrano 3.1
# See http://stackoverflow.com/questions/29168/deploying-a-git-subdirectory-in-capistrano/6969505#6969505 for instructions on how
# to install from a subdirection
# As of Capistrano 3.3.3, you can now use the :repo_tree configuration variable,
# http://capistranorb.com/documentation/getting-started/configuration/
lock '3.6.1'
set :application, ->{YAML.load_file('config/deploy.yml')[fetch(:stage)][:directory]}
set :repo_url, ->{YAML.load_file('config/deploy.yml')[fetch(:stage)][:repo_url]}
set :branch, ->{YAML.load_file('config/deploy.yml')[fetch(:stage)][:branch]}

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/home/rails/muti_tree/#{fetch(:stage)}"

# Default value for :scm is :git
# set :scm, :git
set :repo_tree, 'src/ruby/meetings'
# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, ['config/database.yml','config/secrets.yml','config/environment_params.yml']

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5



