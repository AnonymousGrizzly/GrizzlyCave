<?php
header("Access-Control-Allow-Origin: https://www.grizzly-cave.com");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
include_once 'config/core.php';
include_once 'libs/php-jwt-main/src/BeforeValidException.php';
include_once 'libs/php-jwt-main/src/ExpiredException.php';
include_once 'libs/php-jwt-main/src/SignatureInvalidException.php';
include_once 'libs/php-jwt-main/src/JWT.php';
use \Firebase\JWT\JWT;

include_once 'config/database.php';
include_once 'objects/user.php';

$database = new Database();
$db = $database->getConnection();
$user = new User($db);
$data = json_decode(file_get_contents("php://input"));
$user->username = $data->username;
$username_exists = $user->assignUserData();



if($username_exists && password_verify($data->password, $user->password)){
    $token = array(
       "iat" => $issued_at,
       "exp" => $expiration_time,
       "iss" => $issuer,
       "data" => array(
           "user_id" => $user->user_id,
           "username" => $user->username
       )
    );
    http_response_code(200);
 
    // generate jwt
    $jwt = JWT::encode($token, $key, 'HS256');
    echo json_encode(
        array(
            "message" => "Login successful",
            "jwt" => $jwt,
            "user" =>  array(
                "user_id" => $user->user_id,
                "username" => $user->username
            )
        )
    );
}else{
    if(empty($data->username)){
        http_response_code(411);
        echo json_encode(array("message" => "Username required."));
    }else if(empty($data->password)){
        http_response_code(411);
        echo json_encode(array("message" => "Password required."));
    }else{
    http_response_code(401);
    echo json_encode(array("message" => "Login failed."));
    }
}
?>