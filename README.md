# a Gsn project w/Neo4j

[![Code Climate](https://codeclimate.com/github/pdipietro/gsn.png)](https://codeclimate.com/github/pdipietro/gsn)
[![Build Status](https://travis-ci.org/pdipietro/gsn.png)](https://travis-ci.org/pdipietro/gsn)
[![Coverage Status](https://img.shields.io/coveralls/pdipietro/gsn.svg)](https://coveralls.io/r/pdipietro/gsn)
[![Coverage Status](https://coveralls.io/repos/pdipietro/gsn/badge.png)](https://coveralls.io/r/pdipietro/gsn)
------



# Run a session

#### Start the machine

1. login as joinple
2. open a terminal
3. cd $HOME/joinple

#### Download the latest github version

1. git pull
2. bundle install

#### Reinitialize the DB, if needed 

1. cd $HOME/joinple/db/neo4j/development/data con explora risorse
	* spostare nel cestino la directory graph.db
2. Tornare su terminal
	* rm $HOME/joinple/db/neo4j/development/data/log/*.log
  * cd $HOME/joinple 
  * sh ./joinple_load_initial.sh

#### Run the machine

1. rake neo4j:start
2. rails s -b0.0.0.0

## Stop

1. ctrl-c
2. rake neo4j:stop







# Joinple virtual machine installation


## Install on Ubuntu 14.04 LTS - Desktop

Video: https://www.youtube.com/watch?v=hiPQynmnsiI

Open a terminal

~$ sudo loadkeys it

Install the keyboard !!!!!
Load language support for: it, en

~$ Sudo apt-get update

###### -------------------  saved as  Ubuntu14.04 base  ---------------------

## Install Vmware tools 

Install Vmware tools
	1. Go to Virtual Machine > Install VMware Tools (or VM > Install VMware Tools).

Note: If you are running the light version of Fusion, or a version of Workstation without VMware Tools, or VMware Player, you are prompted to download the Tools before they can be installed. Click Download Now to begin the download.
	2. In the Ubuntu guest, run these commands:
		a. Run this command to create a directory to mount the CD-ROM:

sudo mkdir /mnt/cdrom

When prompted for a password, enter your Ubuntu admin user password.

Note: For security reasons, the typed password is not displayed. You do not need to enter your password again for the next five minutes. 
		b. Run this command to mount the CD-ROM:

sudo mount /dev/cdrom /mnt/cdrom or sudo mount /dev/sr0 /mnt/cdrom
		c. The file name of the VMware Tools bundle varies depending on your version of the VMware product. Run this command to find the exact name:

ls /mnt/cdrom
		d. Run this command to extract the contents of the VMware Tools bundle:

tar xzvf /mnt/cdrom/VMwareTools-x.x.x-xxxx.tar.gz -C /tmp/

Note: x.x.x-xxxx is the version discovered in the previous step.
		e. Run this command to change directories into the VMware Tools distribution:

cd /tmp/vmware-tools-distrib/
		f. Run this command to install VMware Tools:

sudo ./vmware-install.pl -d

Note: The -d switch assumes that you want to accept the defaults. If you do not use -d, press Return to accept each default or supply your own answers.
	3. Run this command to reboot the virtual machine after the installation completes:

sudo reboot

###### -------------------  saved as Vmware tools installed  -------------------

## Remove all unuseful applications

1 Andare su Ubuntu Software Center e rimuovere tutto quello che non serve [NON RIMUOVERE BLUETOOTH] (giochi, open office, etc.)
2 Lasciare su Home solo Desktop e Downloads

###### -------------------  saved as application removed  ---------------------

## Install curl, rvm, Ruby, Rails, git

~$ sudo apt-get install curl

~$ sudo apt-get autoremove

~$ \curl -sSL https://get.rvm.io | bash -s stable

If above in error then use 
$ command curl -sSL https://rvm.io/mpapis.asc | gpg --import -

Close the terminal and open a new one

~$ ~/.rvm/scripts/rvm

~$ rvm requirements

~$ rvm install ruby

~$ rvm use ruby --default

~$ rvm rubygems current

~$ gem install --no-rdoc --no-ri rails

~$ rails -v

Rails 4.2.4

~$ ruby -v

ruby 2.2.1p85 (2015-02-26 revision 49769) [x86_64-linux]

Installare git

~$ sudo apt-get install git

###### -------------------  curl, rvm, Ruby, Rails, git installed  ---------------------

## Install java and Node.js

~$ sudo mkdir /opt/java

~$ cd /opt/java

~$ sudo wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.tar.gz"

~$ sudo tar -zxvf jdk-8u45-linux-x64.tar.gz

~$ cd jdk1.8.0_45/

~$ sudo update-alternatives --install /usr/bin/java java /opt/java/jdk1.8.0_45/bin/java 100  

~$ sudo update-alternatives --config java

~$ sudo update-alternatives --install /usr/bin/jar jar /opt/java/jdk1.8.0_45/bin/jar 100

~$ sudo update-alternatives --config jar

~$ export JAVA_HOME=/opt/java/jdk1.8.0_45/	

~$ export JRE_HOME=/opt/java/jdk1.8.0._45/jre 	

~$ export PATH=$PATH:/opt/java/jdk1.8.0_45/bin:/opt/java/jdk1.8.0_45/jre/bin

~$ sudo apt-get install -y nodejs

###### -------------------  saved as JAVA & NODE.js installed  ---------------------

## Latest settings


####Setting 40.000 open file on Neo4j

You need to add the following entries into the /etc/security/limits.conf file

joinple   soft    nofile  40000

joinple   hard    nofile  40000

####Download editor sublime text

~$ git clone https://github.com/pdipietro/joinple.git

cd joinple

bundle install

~/joinple$ rake neo4j:install

# Config and run

## Initial config

1. in the ~/joinple/db/neo4j/development/conf/neo4j-server.properties
	dbms.security.auth_enabled=false

2. in the /etc/hostname change the host name as
	JPL-<""|test|development|demo>

3. in ~/joinple enable autologin
	cp ~/joinple/50-myconfig.conf /etc/lightdm/lightdm.conf.d

## Run

1. login as joinple
2. open a terminal
3. cd joinple
4. rake neo4j:start
5. rails s -b0.0.0.0

## Stop

1. ctrl-c
2. rake neo4j:stop


# Bundle update

1. Development: bundle update
2. Test:				bundle update rails --group test


# Autorun server config

## Definitions

### Base setting
sudo ln -s  /home/joinple/joinple/autostart.js  /etc/init.d/joinple

### Stage Type

Stage type can be one of the following: **(development|test|production)**

### Server name (convention over configuration)

All server must follow the following name convention, case insensitive:

name = <JPL-><stagetype><number?><-production>
where:
**JPL-**      	: Joinple identification prefix, or the Joinple License Owner Code (TBD)
**stagetype** 	: one of (development|test|production)
**number**			: an optional number to allow several servers
**-production**	: an optional stage to be tested

#### Synonyms

The following synonims are allowed:

**development** : one of (dev|development)
**production**	: one of (depl|deploy|deployment|prod|production|demo)

### Main differences between stage types

The main differences between stage types are the following:

**Development**: in this stage the configuration is determined by the developer. No help is given by the system. The system (rails) runs in development mode, with debugging enabled and low performances.
The config file: /joinple/config/environments/development.rb

**test**: In this stage the database is deleted and rebuilt from the basic DB configuration. 
All data inserted into the system will be lost every time the system is restarted or the automatic tests run. The system (rails) runs in test mode, medium performances
The config file: /joinple/config/environments/test.rb

**production**: The database is preserved and backuped. The system is public open and can be accessed from the internet without limitations. The system (rails) runs in production mode, no debug, system cache enabled and other optimizations.
The config file: /joinple/config/environments/production.rb

**test-production**: it a special configuration to allow testing a production environment. Everything is the same as development, but the system is not open to the internet.
The config file: /joinple/config/environments/production.rb

# Start and Stop the server

The test and production servers will start and stop automatically at startup and shutdown.

They can be manually started and stopped running the command in a shell opened in the $HOME/joinple directory: `bash ./autorun.sh (start|restart|stop)` 

## Ruby & Rails upgrade

### DO NOT EXECUTE! IS A PAIN!

Attention needed while upgrading from the ruby 2.2.1 to the ruby 2.2.2 

1. migration
	* rvm migrate 2.2.1 2.2.2
2. reinstall bundle
	* gem install bundler
	* bundle install
3. sudo apt-get install libgmp-dev

# Reinstall RVM and Ruby

## Remove RVM

$ rvm implode
Are you SURE you wish for rvm to implode?
This will recursively remove /home/user/.rvm and other rvm traces?
(anything other than 'yes' will cancel)

You will see the following output on the screen ..
Removing rvm-shipped binaries (rvm-prompt, rvm, rvm-sudo rvm-shell and rvm-auto-ruby)
Removing rvm wrappers in /home/user/.rvm/bin
Hai! Removing /home/user/.rvm
/home/user/.rvm has been removed.

Note you may need to manually remove /etc/rvmrc and ~/.rvmrc if they exist still.
Please check all .bashrc .bash_profile .profile and .zshrc for RVM source lines and delete or comment out if this was a Per-User installation.
Also make sure to remove `rvm` group if this was a system installation.
Finally it might help to relogin / restart if you want to have fresh environment (like for installing RVM again).

## Reinstall RVM again

Reinstall rvm again .. following command installs the stable version of RVM.

$ \curl -sSL https://get.rvm.io | bash -s stable --ruby

Then install required version of ruby ..

$ rvm install 2.1.0

$ rvm use 2.1.0

You can set a version of Ruby to use as the default for new shells. Note that this overrides the ‘system’ ruby

$ rvm use 2.1.0 --default


 
Then follow instructions above

#Post install messages

##Post-install message from haml:

HEADS UP! Haml 4.0 has many improvements, but also has changes that may break
your application:

* Support for Ruby 1.8.6 dropped
* Support for Rails 2 dropped
* Sass filter now always outputs <style> tags
* Data attributes are now hyphenated, not underscored
* html2haml utility moved to the html2haml gem
* Textile and Maruku filters moved to the haml-contrib gem

For more info see:

http://rubydoc.info/github/haml/haml/file/CHANGELOG.md

##Post-install message from httparty:
When you HTTParty, you must party hard!
