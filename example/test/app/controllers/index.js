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
        	var lat = null;
        	var lng = null;    	
            var vehicle_data = mojio_client.getResults(Vehicle, result);  // Helper function to get the results.    
            if (vehicle_data[0].LastLocation != null) {           
	        	lat = parseFloat(vehicle_data[0].LastLocation.Lat);
	        	lng = parseFloat(vehicle_data[0].LastLocation.Lng);
            	Ti.API.info("lat is: " + lat);
            	Ti.API.info("lng is: " + lng);
            }
            loadmap(lat, lng); 
        }
    });
}

//load map and set the pin at the obtained latitude and longitude
function loadmap(lat, lng) {

	var anImageView = Ti.UI.createImageView({
           image : '/images/pin.jpg', //setting label as a blob
           width : '20',
           height : 'auto',
    });
	if (lat != null && lng != null) {
		map1.region.latitude = lat;
    	map1.region.longitude = lng;
    	Ti.API.info("map LAT: " + map1.region.latitude);
 
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
	    Ti.API.info("map LAT3: " + map1.region.latitude);
    	window.open();
    	alert("Location is: "+lat+", "+lng);
    }
	else {
		alert('No Location Found.');

	}

}

$.index.open();