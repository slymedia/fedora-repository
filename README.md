# fedora-server
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
