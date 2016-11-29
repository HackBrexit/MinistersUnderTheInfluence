# muti-frontend

Visualisations for the Ministers Under the Influence project


## Getting it going

### Running the application directly on your machine

1. Install Node.js
2. Open a terminal in this folder
3. `npm install`
4. `npm run build`
5. `npm start`

### Running the application using vagrant

#### Pre-requisites

* Download and install vagrant from https://www.vagrantup.com/downloads.html

#### Running the application

1. Open a terminal in this folder
1. `vagrant up`

    The first time this is run it will need to download the base virtual machine image,
which may take some time, depending on the speed of your internet connection (it took
~30 minutes for me).

1. `vagrant ssh`

    (This will connect to the terminal of the virtual machine.)

    1. `cd /vagrant/src/js/frontend`
    1. `./bin/run.sh`

        This will compile and run the application.

1. Back on your host machine, open a web browser and go to:

        http://localhost:3000/

Hack on src/components/app.js
