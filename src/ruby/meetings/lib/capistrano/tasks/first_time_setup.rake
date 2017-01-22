
namespace :deploy do

  desc 'delete the remote directory'
  task :delete_remote_directory=>[:set_rails_env] do
    on roles(:web) do
      execute "[-d #{release_path}] && rm -rf #{release_path}"
    end
  end

  namespace :db do
    desc 'Runs rake db:create'
    task :create => [:set_rails_env] do
      on roles(:db) do
        info '[deploy:create] Run `rake db:create`' 
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, "db:create"
          end
        end
      end
    end

    desc 'Runs rake db:drop'
    task :drop => [:set_rails_env] do
      on roles(:db) do
        info '[deploy:create] Run `rake db:drop`' 
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, "db:drop"
          end
        end
      end
    end

    desc 'Runs rake db:seed'
    task :seed => [:set_rails_env] do
      on roles(:db) do
        info '[deploy:seed] Run `rake db:seed`' 
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, "db:seed"
          end
        end
      end
    end
  end

  desc 'copy shared config/*.yml files'
  task :copy_config do 
    on roles(:app,:db), in: :sequence, wait: 5 do 
      fetch(:linked_files).each  do |f|
        upload! f,"#{deploy_to}/shared/config/"
      end
    end
  end


  desc 'first time setup'
  task :first_time  do
    after   'deploy:check:make_linked_dirs','deploy:copy_config'
    after   'deploy:migrate', 'deploy:db:seed'
    before  'deploy:migrate', 'deploy:db:drop'
    before  'deploy:migrate', 'deploy:db:create'
    Rake::Task[:deploy].invoke
  end

end
