<?php
session_start();
require '../app/core/Router.php';

$router = new Router();
$router->addRoute('GET', '/login', 'AuthController@login');
$router->addRoute('POST', '/login', 'AuthController@login');
$router->addRoute('GET', '/register', 'AuthController@register');
$router->addRoute('POST', '/register', 'AuthController@register');
$router->addRoute('GET', '/logout', 'AuthController@logout');
$router->addRoute('GET', '/home', 'HomeController@index');

$router->dispatch();
?>