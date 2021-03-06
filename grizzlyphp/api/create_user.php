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
$db = $database->getConnection(); //get connection 
 
$user = new User($db);  //create new object for method usage
$data = json_decode(file_get_contents("php://input"));
 

$user->username = $data->username;
$user->email = $data->email;
$user->password = $data->password;

$stmt = $user -> getUserByEmail(); //see if email exists


if($stmt->rowCount()>0){  //if database returns a row, there's an email
    http_response_code(409);
    echo json_encode(array("message" => "Email already exists"));
    exit();
}

$stmt = $user -> getUserByUsername(); //if database returns a row, there's a username

if($stmt->rowCount()>0){
    http_response_code(409);
    echo json_encode(array("message" => "Username already exists")); //return message
    exit();
}

if(!empty($user->username) && !empty($user->email) && !empty($user->password) && $user->create() ){ //if able to create user
    $token = array(
        "iat" => $issued_at,
        "exp" => $expiration_time,
        "iss" => $issuer,
        "data" => array(
            "user_id" => $user->user_id,
            "username" => $user->username
        )
     );
    http_response_code(201);

    $jwt = JWT::encode($token, $key, 'HS256');
    echo json_encode(
        array(
            "message" => "User created",
            "jwt" => $jwt,
            "data" => array(
                "user_id" => $user->user_id,
                "username" => $user->username
            )
        )
    );
}else{ // if unable to create user
    http_response_code(400);
    echo json_encode(array("message" => "Unable to create user."));
}

?>