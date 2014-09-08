Overview
========

W3C valdidator
==============

- http://validator.w3.org/
- http://localhost:8880/w3c-validator/

validator.nu - HTML5 validation
===============================

- http://about.validator.nu/
- http://localhost:8888/html5/


CSS validator
=============

- http://www.css-validator.org/
- http://localhost:8080/css-validator/

Compile css-validator WAR file
------------------------------

:
    apt-get install ant cvs

    curl -L -o css-validator-standalone.zip  https://github.com/w3c/css-validator-standalone/archive/master.zip
    unzip css-validator-standalone.zip
    cd css-validator-standalone-master/


Achecker - WCAG / Stanca act
============================


- http://achecker.ca/
- http://localhost:8880/achecker/

- username: admin
- password: admin
- API Key: 78495f0ba58afa678a87e97733ba7e96b9143433

Fix Achecker
------------

Blank page after login
In /var/www/html/achecker/include/classes/User.class.php line 22

change this::

    define('AC_INCLUDE_PATH', '../../include/');

to::

    define('AC_INCLUDE_PATH', dirname(__FILE__) . '/../../include/');
