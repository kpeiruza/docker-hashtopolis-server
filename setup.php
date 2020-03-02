<?php

require_once(dirname(__FILE__) . "/../inc/db.php");
use DBA\AccessGroupUser;
use DBA\Config;
use DBA\QueryFilter;
use DBA\RightGroup;
use DBA\Factories;;
use DBA\User;

require_once(dirname(__FILE__) . "/../inc/load.php");

    $pepper = array(Util::randomString(50), Util::randomString(50), Util::randomString(50));
    $crypt = file_get_contents(dirname(__FILE__) . "/../inc/Encryption.class.php");
    $crypt = str_replace("__PEPPER1__", $pepper[0], str_replace("__PEPPER2__", $pepper[1], str_replace("__PEPPER3__", $pepper[2], $crypt)));
    file_put_contents(dirname(__FILE__) . "/../inc/Encryption.class.php", $crypt);
    
    // set CSRF private key
    $key = Util::randomString(20);
    $csrf = file_get_contents(dirname(__FILE__) . "/../inc/CSRF.class.php");
    $csrf = str_replace("__CSRF__", $key, $csrf);
    file_put_contents(dirname(__FILE__) . "/../inc/CSRF.class.php", $csrf);
    
    if ($FACTORIES::getUserFactory()->getDB(true) === null) {
      //connection not valid
	printf ( "Unable to connect to the Database\n" );
        exit;
    }
?>
