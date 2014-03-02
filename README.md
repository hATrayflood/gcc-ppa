GNU GCC PPA
===========

Porting missing version of gcc from upper/lower LTS to LTS

**if you failed to upgrade, purge and re-install.**

provides
--------
    # trusty
    /usr/bin/gcc-4.5
    /usr/bin/g++-4.5
    # precise
    /usr/bin/gcc-4.8
    /usr/bin/g++-4.8
    /usr/bin/gcc-4.7
    /usr/bin/g++-4.7
    # lucid
    /usr/bin/gcc-4.7
    /usr/bin/g++-4.7
    /usr/bin/gcc-4.6
    /usr/bin/g++-4.6
    /usr/bin/gcc-4.5
    /usr/bin/g++-4.5
    /usr/bin/gcc-4.2
    /usr/bin/g++-4.2

usage
-----
    # get new gcc, maybe replace c/c++ runtime !!
    sudo add-apt-repository ppa:h-rayflood/gcc-upper
    # get old gcc, compiler tools only ...
    sudo add-apt-repository ppa:h-rayflood/gcc-lower
    
    sudo apt-get update
    sudo apt-get dist-upgrade
    sudo apt-get install gcc-N.N
    sudo apt-get install g++-N.N

upstream
--------
http://packages.ubuntu.com/source/trusty/gcc-4.8  
http://packages.ubuntu.com/source/trusty/gcc-4.7  
http://packages.ubuntu.com/source/precise/gcc-4.6  
http://packages.ubuntu.com/source/precise/gcc-4.5  
http://old-releases.ubuntu.com/ubuntu/pool/main/g/gcc-4.2/  

launchpad
---------
https://launchpad.net/~h-rayflood/+archive/gcc-upper  
https://launchpad.net/~h-rayflood/+archive/gcc-lower  

github
------
https://github.com/hATrayflood/gcc-ppa
