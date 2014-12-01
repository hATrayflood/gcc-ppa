GNU GCC PPA
===========

Porting missing version of gcc from upper/lower LTS to LTS

**if you failed to upgrade, purge and re-install.**

provides
--------
    # lucid
    /usr/bin/gcc-4.0
    /usr/bin/g++-4.0
    /usr/bin/gcc-4.1
    /usr/bin/g++-4.1
    /usr/bin/gcc-4.2
    /usr/bin/g++-4.2
    /usr/bin/gcc-4.5
    /usr/bin/g++-4.5
    /usr/bin/gcc-4.6
    /usr/bin/g++-4.6
    /usr/bin/gcc-4.7
    /usr/bin/g++-4.7
    /usr/bin/gcc-4.8
    /usr/bin/g++-4.8
    /usr/bin/gcc-4.9
    /usr/bin/g++-4.9
    # precise
    /usr/bin/gcc-4.5
    /usr/bin/g++-4.5
    /usr/bin/gcc-4.7
    /usr/bin/g++-4.7
    /usr/bin/gcc-4.8
    /usr/bin/g++-4.8
    /usr/bin/gcc-4.9
    /usr/bin/g++-4.9
    # trusty
    /usr/bin/gcc-4.5
    /usr/bin/g++-4.5
    /usr/bin/gcc-4.9
    /usr/bin/g++-4.9

usage
-----
    # get old gcc, compiler tools only ...
    sudo add-apt-repository ppa:h-rayflood/gcc-lower
    # get new gcc, maybe replace c/c++ runtime !!
    sudo add-apt-repository ppa:h-rayflood/gcc-upper
    
    sudo apt-get update
    sudo apt-get dist-upgrade
    sudo apt-get install gcc-N.N
    sudo apt-get install g++-N.N

upstream
--------
https://launchpad.net/ubuntu/dapper/+source/gcc-4.0  
https://launchpad.net/ubuntu/lucid/+source/gcc-4.1  
https://launchpad.net/ubuntu/hardy/+source/gcc-4.2  
https://launchpad.net/ubuntu/precise/+source/gcc-4.5  
https://launchpad.net/ubuntu/precise/+source/gcc-4.6  
https://launchpad.net/ubuntu/trusty/+source/gcc-4.7  
https://launchpad.net/ubuntu/trusty/+source/gcc-4.8  
https://launchpad.net/ubuntu/utopic/+source/gcc-4.9  

launchpad
---------
https://launchpad.net/~h-rayflood/+archive/gcc-lower  
https://launchpad.net/~h-rayflood/+archive/gcc-upper  

github
------
https://github.com/hATrayflood/gcc-ppa
