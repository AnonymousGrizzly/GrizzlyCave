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

include_once './config/database.php';
include_once './objects/folder_system.php';

if($_SERVER['REQUEST_METHOD']==="OPTIONS"){
    http_response_code(200);
    die;
}

$database = new Database();
$db = $database->getConnection();
$data = json_decode(file_get_contents("php://input"));
$jwtData=isset($data->jwt) ? $data->jwt : "";


if(!$jwtData){
    http_response_code(401);
    die(json_encode(array("message" => "Access denied."))); 
}

$decoded = JWT::decode($jwtData, new Key($key, 'HS256'));
$folder_system = new FolderSystem($db);
if(isset($data->id)){
    $id = $data->id;
}else{
    $id = null;
}
$result = $folder_system->getParentFolder($id)->fetch();
http_response_code(200);
echo json_encode(array("parentfolder_id" => $result["parentfolder_id"]));