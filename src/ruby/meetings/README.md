# README
* Ruby version
2.3.1
* System dependencies
You need to have RVM set up. Checkout, cd into the directory, this will create an RVM configuratio, then
gem install bundler
bundle
You then need to have database.yml, secrets.yml, set up. Copy from database.yml.example, secrets.yml.example and edit as required.
rails db:create:all
rails db:migrate
rake
and you should be good to go
