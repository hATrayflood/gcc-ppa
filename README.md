GNU GCC PPA
===========

Porting missing version of gcc from upper/lower LTS to LTS

**if you failed to upgrade, purge and re-install.**

provides
--------
    # lucid
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
http://old-releases.ubuntu.com/ubuntu/pool/main/g/gcc-4.2/  
http://packages.ubuntu.com/source/precise/gcc-4.5  
http://packages.ubuntu.com/source/precise/gcc-4.6  
http://packages.ubuntu.com/source/trusty/gcc-4.7  
http://packages.ubuntu.com/source/trusty/gcc-4.8  
http://packages.ubuntu.com/source/utopic/gcc-4.9  

launchpad
---------
https://launchpad.net/~h-rayflood/+archive/gcc-lower  
https://launchpad.net/~h-rayflood/+archive/gcc-upper  

github
------
https://github.com/hATrayflood/gcc-ppa
