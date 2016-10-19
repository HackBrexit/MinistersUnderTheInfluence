namespace :apache do
  def domain
    fetch(:apache_domain)
  end
  def config_file
    "#{fetch(:application)}.conf"
  end  
  def subdomain
    false
  end
  desc "Adds Apache2 configuration and enables it."
  task :create do
    puts "\n\n=== Adding Apache2 Virtual Host for #{domain}! ===\n\n"
    config = <<-CONFIG
<VirtualHost *:80>
  ServerName #{domain}
  ServerAlias *.#{domain}
  DocumentRoot #{File.join(deploy_to, 'current', 'public')}
  PassengerRuby /home/ubuntu/.rvm/gems/#{File.read('.ruby-version').split[0]}@#{File.read('.ruby-gemset').split[0]}/wrappers/ruby
  RailsEnv #{fetch(:stage)}
  <Directory #{File.join(deploy_to, 'current', 'public')}>
    Allow from all
    Options -MultiViews
  </Directory>
  ErrorLog  #{File.join(deploy_to, 'shared', 'log','error.log')}
  CustomLog  #{File.join(deploy_to, 'shared', 'log','access.log')} combined
</VirtualHost>
CONFIG
    io = StringIO.new(config)

    on roles(:web), in: :groups, limit: 3, wait: 10 do
      upload! io,config_file
      within '/home/ubuntu' do
        execute "sudo mv #{config_file} /etc/apache2/sites-available/"
      end   
      execute "sudo a2ensite #{config_file}"
      execute "sudo service apache2 restart"
    end
  end

  desc "Restarts Apache2."
  task :restart do
    run "sudo /etc/init.d/apache2 restart"
  end

  desc "Removes Apache2 configuration and disables it."
  task :destroy do
    puts "\n\n=== Removing Apache2 Virtual Host for #{config_file}! ===\n\n"
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      begin execute("sudo a2dissite #{config_file}"); rescue; end
      begin execute("sudo rm /etc/apache2/sites-available/#{config_file}"); rescue; end
      execute("sudo /etc/init.d/apache2 restart")
    end
  end

end


