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

~$ sudo apt-get  install curl
~$ sudo apt-get  autoremove

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


Setting 40.000 open file on Neo4j

You need to add the following entries into the /etc/security/limits.conf file
joinple   soft    nofile  40000
joinple   hard    nofile  40000

Download editor sublime text

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

## Run

1. login as joinple
2. open a terminal
3. cd joinple
4. rake neo4j:start
5. rails s -b0.0.0.0

## Stop

1. ctrl-c
2. rake neo4j:stop

