<?php

require_once(dirname(__FILE__) . "/../inc/db.php");
use DBA\AccessGroupUser;
use DBA\Config;
use DBA\QueryFilter;
use DBA\RightGroup;
use DBA\User;

require_once(dirname(__FILE__) . "/../inc/load.php");

    $username = "H8_USER";
    $password = "H8_PASS";
    $email = "H8_EMAIL";
    
    if ($FACTORIES::getUserFactory()->getDB(true) === null) {
      //connection not valid
	printf ( "Unable to connect to the Database\n" );
        exit;
    }

    $FACTORIES::getAgentFactory()->getDB()->beginTransaction();
    
    $qF = new QueryFilter(RightGroup::GROUP_NAME, "Administrator", "=");
    $group = $FACTORIES::getRightGroupFactory()->filter(array($FACTORIES::FILTER => array($qF)));
    $group = $group[0];
    $newSalt = Util::randomString(20);
//    $newHash = Encryption::passwordHash($password, $newSalt);
    $user = new User(0, $username, $email, Encryption::passwordHash($password, $newSalt), $newSalt, 1, 1, 0, time(), 3600, $group->getId(), 0, "", "", "", "");
    $FACTORIES::getUserFactory()->save($user);
    
    // create default group
    $group = AccessUtils::getOrCreateDefaultAccessGroup();
    $groupUser = new AccessGroupUser(0, $group->getId(), $user->getId());
    $FACTORIES::getAccessGroupUserFactory()->save($groupUser);
    $FACTORIES::getAgentFactory()->getDB()->commit();

