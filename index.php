<?php
class APN implements \JsonSerializable
{
    private $aps;
    private $username;
    private $token;
    
    public function __construct(APSObject $aps, string $username = "JsonUser", string $token = "DummyToken123456")
    {
        $this->aps = $aps;
        $this->username = $username;
        $this->token = $token;
    }

    public function jsonSerialize()
    {
        return get_object_vars($this);
    }
}
class APSObject implements \JsonSerializable{
    public $alert;
    public $sound;
    public $category = "ESTECHVMG_CHAT";

    public function __construct(ApsAlert $apsAlert)
    {
        $this->alert = $apsAlert;
        $this->sound = "default";
        $this->category = "ESTECHVMG_CHAT";
    }

    public function jsonSerialize()
    {
        return get_object_vars($this);   
    }
}
class APSAlert implements \JsonSerializable{
    public $title;
    public $body;
    public function __construct(string $body = "Dummy Text Body")
    {
        $this->title = "Notificacion ChatApp Vicente";
        $this->body = $body;
    }

    public function jsonSerialize()
    {
        return get_object_vars($this);   
    }
}
function isAllDataSent() : bool{
    return (isset($_GET['message']) && isset($_GET['username']) && isset($_GET['token']) );
}

//INIT

if(isAllDataSent()){
    $deviceToken = $_GET['token']; // Token Device
    $message = $_GET['message']; // Message to show the user
    $username = $_GET['username']; // UserName to show the user
    //Object instantiation
    
    $alert = new APSAlert($message);
    $aps = new APSObject($alert);
    $alertObject= new APN($aps,$username,$deviceToken);
    $alertJson = json_encode($alertObject);
    echo $alertJson .'<br>';

    //Parámetros
    $pem_file = 'apns-dev-cert.pem'; //Ruta del fichero del certificado
    $pem_secret = 'Estech20'; //Contraseña del certificado
    $apns_topic = 'com.estechvmg.ChatApp'; //App Bundle identifier

    //URL producción
	// $url = "https://api.push.apple.com/3/device/$deviceToken";
    //URL testing
 	$url = "https://api.development.push.apple.com/3/device/$deviceToken";
    // OPEN CONNECTION TO APNS SERVER :
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 2);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $alertJson);
    curl_setopt($ch, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_2_0);
    curl_setopt($ch, CURLOPT_HTTPHEADER, array("apns-topic: $apns_topic"));
    curl_setopt($ch, CURLOPT_SSLCERT, $pem_file);
    curl_setopt($ch, CURLOPT_SSLCERTPASSWD, $pem_secret);
    $response = curl_exec($ch);
    $httpcode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    var_dump($response);
    var_dump($httpcode);
}else{
    
    echo 'Not All Data was sent';
}

//JSON SCHEME
/*
{
    "aps":{
        "alert": {
            "title": "Notificación recibida de la aplicacion push",
            "body": "Acepta el nuevo evento para mas informacion"
        },
        "sound": "default",
	"badge": 3,
        "link_url": "https://escuelaestech.es",
        "category": "TEST_PUSH"
    },
    "username": "Vicente"
}
*/
?>