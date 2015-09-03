# fedora-repository
Installation Framework for installing Fedora Commons Database Repository Server

Directory Contents
-------------------

 fedora-repository-	Top Level directory. The idea here is this directory 
			holds all of the contents of the installation and 
			has some well known directories within it 
			(sbin,bin,etc,lib). It could be analogous to a 
			/usr/local directory. 

	- bin 		Used to keep useful scripts for managing the 
			repository. Also is where all the dependency 
			packages are linked to. 
			
	- etc		This is where example config files and initial 
			settings are stored. Most notably is the env.sh 
			and database.sh files that declare variables for
			our installation. 
	
	- packages	This is the directory where all dependency packages
			are built into. Source code is downloaded into the 
			src directory (this gets created during the install) 
			and compiled in src by declaring a ./configure --prefix=
			/opt/fedora-repository/packages/<package_name>-<version>.
			From this packages directory structure each application 
			is sym-linked into the /opt/fedora-repository/<dir> directories. 
			This way we only have to declare /opt/fedora-repository/bin 
			and /opt/fedora-repository/lib in the environment variables 
			but yet pick up all the applications we build manually. 
	
	- sbin		This is where all the scripts to do the
			installation are stored. Once the 
			installation is running you would generally just 
			use bin to add in extra scripts as you develop them. 
			
	- .bash_profile	This file is set up to source the whole environment 
			if you set the home directory of the local fedora user 
			to this location (ie. /opt/fedora-repository).

############################
#
# Quick installation
#
############################
  1.)  Install a minimal CentOS 6 based server. 
  
  2.) add a chkconfig service file that will do the installation. This is also a handy way to make a Virtual Machine template. If you add the following code to a base CentOS 6 minimal Virtual Machine then when you create a new server it'll automatically install fedora commons on the server. 
  
 		- add the following code to a file called /etc/init.d/fedora-installer
 		- execute:  `chkconfig --add fedora-installer; chkconfig fedora-installer on`
 		- reboot 
 when the machine boots it will run the service and install fedora commons on the server. Then disables itself after it's run. 

Here's the code:
######################### /etc/init.d/fedora-installer ######################
	#!/bin/bash
	#
	# fedora-installer This will install initial software for a fedora commons 3.8.1 server
	# 
	# chkconfig: 2345 9 20
	# description: do things on firstboot to setup the server

	randpw ()
	{
		date +%s | sha256sum | base64 | head -c 7 ; echo
	}
	install-software()
	{
		yum -y install git gettext sendmail
	}
	start()
	{
	    	cd /opt;
	    	git clone https://github.com/slymedia/fedora-repository.git;
	    	chkconfig slymedia-installer off;
		return 0;
	}

	configure-ip()
	{
		#
		# Note: the following variable will need to be updated for the type of ethernet interface on your host. 
		#        change the venet0:0 to whatever is on your machine (ie. eth0). 
		#
		IPADDR=`ifconfig -a venet0:0 | grep inet | awk '{print $2}' | awk -F: '{print $2}'`;
		sed -i "s|xxx\.xxx\.xxx\.xxx|${IPADDR}|g" /opt/fedora-repository/installer.sh
		return 0;
	}

	configure-email()
	{
		sed -i "s|youremail@domain.com|<REPLACE WITH YOUR EMAIL>|g" /opt/fedora-repository/installer.sh
		return 0;
	}

	create-fuser-password()
	{
		FUSER_PASS=`randpw`
		sed -i "s|fedora2014|$FUSER_PASS|g" /opt/fedora-repository/installer.sh
	        return 0;
	}
	create-fedoradbpass()
	{
	 	FDB_PASS=`randpw`
	        sed -i "s|fedoradbpass|$FDB_PASS|g" /opt/fedora-repository/installer.sh
	        return 0;
	}
	create-fedoraadminpass()
	{
	        FADMIN_PASS=`randpw`
	        sed -i "s|fedoraadminpass|$FADMIN_PASS|g" /opt/fedora-repository/installer.sh
	        return 0;
	}
	create-fgsadminpass()
	{
	       FGSADMIN_PASS=`randpw`
	       sed -i "s|fgsadminpass|$FGSADMIN_PASS|g" /opt/fedora-repository/installer.sh
	       return 0;
	}
	create-mysqlroot()
	{
	       MYSQL_PASS=`randpw`
	       sed -i "s|mysqlroot|$MYSQL_PASS|g" /opt/fedora-repository/installer.sh
	       return 0;
	}
	do-install()
	{
		#
		# Note: it is assumed that we are installing this into /opt/fedora-repository
		#      update the path if you change this installation prefix
		#
	        chmod 755 /opt/fedora-repository/installer.sh
		cd /opt/fedora-repository
	        ./installer.sh >/opt/fedora-repository/installation.log 2>&1
	}

	case "$1" in
	  start)
	    	echo $"Installing fedora-repository software in /opt.... "
		install-software
		start
		configure-ip
		configure-email
		create-fuser-password
		create-fedoradbpass
		create-fedoraadminpass
		create-fgsadminpass
		create-mysqlroot
		do-install
	  ;;
	  stop|status|restart|reload|force-reload)
	   # do nothing
	 ;;
	esac
##############  /etc/init.d/fedora-installer  ##############################

############################
#
# Manual installation
#
############################

Alternatively you can just install this manually by not doing the above step of adding the chkconfig service. Instead do the following:

	- Install CentOS 6 minimal.
	% mkdir /opt
	% cd /opt;
	% git clone https://github.com/slymedia/fedora-repository.git;
	% chmod 755 /opt/fedora-repository/installer.sh
	% cd /opt/fedora-repository

Now edit the file installer.sh in order to put in the values needed for the installation variables. 
Then just run the installer

	% ./installer.sh >/opt/fedora-repository/installation.log 2>&1
	
