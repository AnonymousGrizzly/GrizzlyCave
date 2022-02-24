<?php
header("Access-Control-Allow-Origin: http://localhost:3000");
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
$jwt=isset($data->jwt) ? $data->jwt : "";

if($jwt){
  $decoded = JWT::decode($jwt, $key, array('HS256'));
  $user->user_id= $decoded->$data->user_id;
  $stmt = $user->getUserByUserId();
  
  $result['email'] = "neki ne dela";
  $result['username'] = "ja, neki ne dela";

  $result = $stmt->fetch_array(MYSQLI_ASSOC);
  http_response_code(200);
  echo json_encode(array("data" => array(
  "email" => $result['email'],
  "username" => $result['username'] 
  )));
}else{
  http_response_code(401);
  echo json_encode(array("message"=>"Unable to retrieve data."));
}


?>