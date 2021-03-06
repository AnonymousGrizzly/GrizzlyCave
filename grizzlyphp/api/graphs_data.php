<?php
header("Access-Control-Allow-Origin: https://www.grizzly-cave.com");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once 'config/core.php';
include_once 'libs/php-jwt-main/src/BeforeValidException.php';
include_once 'libs/php-jwt-main/src/ExpiredException.php';
include_once 'libs/php-jwt-main/src/SignatureInvalidException.php';
include_once 'libs/php-jwt-main/src/JWT.php';
include_once 'libs/php-jwt-main/src/Key.php';

use \Firebase\JWT\JWT;
use Firebase\JWT\Key;

include_once 'config/database.php';
include_once 'objects/user.php';
include_once 'objects/file_system.php';
include_once 'objects/details.php';


if($_SERVER['REQUEST_METHOD']==="OPTIONS"){ //to enable calls from different domains (production mode: react :3000, php :3001)
    http_response_code(200);
    die;
}

$database = new Database();
$db = $database->getConnection(); //get connection

$user = new User($db);
$file = new FileSystem($db);
$details = new Details($db);

$data = json_decode(file_get_contents("php://input"));
$jwt=isset($data->jwt) ? $data->jwt : "";
if(!$jwt){ //Don't do it if there's no token 
    http_response_code(401);
    die( json_encode(array("message" => "No token?"))); 
}

try{
    $decoded = JWT::decode($jwt, new Key($key, 'HS256'));
    $user->user_id = $decoded->data->user_id;
    $file->user_id = $user->user_id;
    $details->user_id= $user->user_id;
    $allfiles = $file->getAllFiles();
    $storagesize = $details->getData();
    http_response_code(200);
    echo json_encode(array("message" => "Success."));
}catch (Exception $e){ //get message if it fails
    http_response_code(401);
    echo json_encode(array(
        "message" => "Cannot display graphs.",
        "error" => $e->getMessage()
    ));
}

?>