<?php
error_reporting(E_ALL);
ini_set('display_errors', '1');

$databases = array (
  'default' =>
  array (
    'default' =>
    array (
      'database' => 'drupal',
      'username' => 'admin',
      'password' => 'changeme',
      'host' => 'mysql-server',
      'port' => '',
      'driver' => 'mysql',
      'prefix' => '',
    ),
  ),
);

// settings for memcache
if(file_exists('sites/all/modules/contrib/memcache/memcache.inc')){
$conf['memcache_servers'] = array('memcache-server:11211'=>'default');
$conf['cache_backends'][] = 'sites/all/modules/contrib/memcache/memcache.inc';
$conf['lock_inc'] = 'sites/all/modules/contrib/memcache/memcache-lock.inc';
$conf['memcache_stampede_protection'] = TRUE;
$conf['cache_default_class'] = 'MemCacheDrupal';
$conf['cache_class_cache_form'] = 'DrupalDatabaseCache';
$conf['page_cache_without_database'] = TRUE;
$conf['page_cache_invoke_hooks'] = FALSE;
}

// settings to allow access to update.php from the users desktop
$update_free_access = TRUE;

// prevent the drupal http request fails from showing in the error report
$conf['drupal_http_request_fails'] = FALSE;

// set the default files directory to something writeable
$conf['file_public_path'] = '/var/www/site/files';
