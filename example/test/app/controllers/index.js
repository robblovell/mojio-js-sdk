var authURL;
var MapModule = require('ti.map');
var accessToken = "";
var lat=0.0;
var lng=0.0;
var MojioClient = require('mojiojs/lib/titanium/MojioClient');

var App, MojioClient, buildMojioMap, config, mojio_client;


config = {
        application: '21de13d2-a016-4fed-8e5e-43f0432ea717',
        redirect_uri: 'myfirstappeceleraterapp://',
        hostname: 'api.moj.io',
        version: 'v1',
        port: '443',
        scheme: 'https',
        live: false, // This will connect your app to the sandbox server, replace with true to go live.
        appname : "myfirstappeceleraterapp"
    };


var rc = MapModule.isGooglePlayServicesAvailable();
switch (rc) {
 case MapModule.SUCCESS:
        Ti.API.info('Google Play services is installed.');
 break;
 case MapModule.SERVICE_MISSING:
        alert('Google Play services is missing. Please install Google Play services from the Google Play store.');
 break;
 case MapModule.SERVICE_VERSION_UPDATE_REQUIRED:
        alert('Google Play services is out of date. Please update Google Play services.');
 break;
 case MapModule.SERVICE_DISABLED:
        alert('Google Play services is disabled. Please enable Google Play services.');
 break;
 case MapModule.SERVICE_INVALID:
        alert('Google Play services cannot be authenticated. Reinstall Google Play services.');
 break;
 default:
        alert('Unknown error.');
}

var win = Ti.UI.createWindow({backgroundColor: 'white'});

var map1 = MapModule.createView({
    userLocation: true,
    mapType: MapModule.NORMAL_TYPE,
    animate: true,
    region: {latitude: -33.87365, longitude: 151.20689, latitudeDelta: 0.1, longitudeDelta: 0.1 },
    height: '60%',
    top: '40%',
    left: '2.5%',
    width: '95%'
});


mojio_client = new MojioClient(config);
function LoginButton() {
	Ti.API.info("mojio_client.isauthorized() " + mojio_client.isauthorized());    
	if(mojio_client.isauthorized()===false) {
		//use webview to obtain the token
		var webview = mojio_client.authorize(config.redirect_uri);  
		window = Titanium.UI.createWindow();	
	   	window.add(webview);
    	window.open({modal:true});     	
	} else {		
		mojio_client.token(function(error, result) {
			if (error) {
	    		alert("Authorize Redirect, token could not be retreived:" + error);
	    	} else {
				alert("Authorization Successful.");
				Titanium.UI.createAlertDialog({title:'Your App has been authroized!', message:result}).show();
				Ti.API.info("result " + result);    
				accessToken = result;
			}		
		}); 		
	}	
}

function GetTokenButton(){	
	mojio_client.token(function(error,result) {  
			if (error) {
	    		alert("Authorize Redirect, token could not be retreived:" + e);
	    	} else {
				alert("Authorization Successful.");
				Titanium.UI.createAlertDialog({title:'Your App has been authroized!', message:result}).show();
				Ti.API.info("result " + result);    				
			}		
		}); 	
}

function ObtainDataButton() {	
	var Vehicle = mojio_client.model("Vehicle"); // Gets a trip model schema.
	Ti.API.info("Vehicle:" + Vehicle);
    mojio_client.get(Vehicle, {}, function(error, result) {
        var e = error.error;
        //var test = this.responseText;
       
        if (e) {
        	Ti.API.info("get data returns error:" + e);
            console.log(error); // Some error occured.
        } else {        	
            var vehicle_data = mojio_client.getResults(Vehicle, result);  // Helper function to get the results.                    
	        lat = parseFloat(vehicle_data[0].LastLocation.Lat);
	        lng = parseFloat(vehicle_data[0].LastLocation.Lng);
            Ti.API.info("lat is: " + lat);
            Ti.API.info("lng is: " + lng);
            loadmap();
              
        }
    });
	
}



//load map and set the pin at the obtained latitude and longitude
function loadmap() {
	map1.region.latitude = lat;
    map1.region.longitude = lng;
    Ti.API.info("map LAT: " + map1.region.latitude);
 
	var anImageView = Ti.UI.createImageView({
                image : '/images/pin.jpg', //setting label as a blob
                width : '20',
                height : 'auto',
            });
    
    var random = MapModule.createAnnotation({
    	latitude: lat,
    	longitude: lng,	   
    	image: anImageView,
	    pincolor: MapModule.ANNOTATION_AZURE,
	    draggable: false
	});
        
    var mapview = MapModule.createView({
    	mapType: MapModule.NORMAL_TYPE,
    	region: {latitude: lat, longitude: lng, latitudeDelta: 0.1, longitudeDelta: 0.1 }
	});
    
    mapview.addAnnotation(random);
    window.add(mapview);     
    window.open();
    Ti.API.info("map LAT3: " + map1.region.latitude);
    alert('last location obtained successfully!');
}


$.index.open();

/*setclient ();
	var webview = Titanium.UI.createWebView();
	webview.setUrl(authURL);  
      
    webview.addEventListener('load',function(e) {
    	//for debug
    	// Titanium.UI.createAlertDialog({title:'url', message:e.url.toString()}).show();    	
    	//TPD, detect the status
    	if (e.url.indexOf("myfirstappeceleraterapp") === 0) {
			
			webview.setVisible(false);
         	// stop the event
        	e.bubble = false;
                  
         	// stop the url from loading        
         	webview.stopLoading();     
        	         
         	window.remove(webview);
         	//localize the accessToken from the redirected URL
         	var tokenIndex = e.url.indexOf("token"); 
         	accessToken = e.url.substring(tokenIndex+6,tokenIndex + 42);         
         	// Titanium.UI.createAlertDialog({title:'AcessToken', message:accessToken}).show();         
         	
         	//obtain
         	obtainData(accessToken);
         	Ti.API.info("obtained LAT: " + lat);              
    	}
    });
    
    function setclient () {
	//set your application ID 
	var appID = '21de13d2-a016-4fed-8e5e-43f0432ea717';	
	//set the OAuth URL and the redirect uri
	authURL = "https://api.moj.io/OAuth2SandBox/authorize?response_type=token&client_id=";
	authURL = authURL + appID+"&redirect_uri=myfirstappeceleraterapp://";	
}



function obtainData(accessToken) {
	var url = "https://api.moj.io:443/v1/Vehicles?limit=10&offset=0&sortBy=Name&desc=false&criteria=";
 	var client = Ti.Network.createHTTPClient({
	     // function called when the response data is available
	     onload : function(e) {
	        
	         var obj = JSON.parse(this.responseText);
	       
	         var Type = obj.Data[0].Type;
	         lat = parseFloat(obj.Data[0].LastLocation.Lat);
	         lng = parseFloat(obj.Data[0].LastLocation.Lng);	        
	         Ti.API.info("Received LAT: " + lat);
	         Ti.API.info("Received LNG: " + lng);
	         Ti.API.info("Received pagesize: " + Type);
	        if(lat!==0 && lng!==0) {
	        	loadmap();	
	        }	         
	     },
	     // function called when an error occurs, including a timeout
	     onerror : function(e) {
	         Ti.API.debug(e.error);
	         alert('error');
	     },
	     timeout : 5000  // in milliseconds
 	});
 	 
 	 client.setRequestHeader("MojioAPIToken",accessToken);
	 url = "https://api.moj.io:443/v1/Vehicles";
 	 Ti.API.info("old url:" + url);
	 // Prepare the connection.
	 client.open("GET", url);
	 // Send the request.
	 client.send();
}
    
    
    
    * 
    * */
	