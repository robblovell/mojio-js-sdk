(function ($) {
    Mojio.Map = function (div, client, options) {
        var settings;
        var _map;

        var _vehicles = {};

        var _follow;

        var init = function (options) {
            settings = $.extend({
                'template': '#eventTemplate',
                'delay': 800,
                'autoCenter': true,
                'location': { lat: 49.278277, lng: -123.116977 }
            }, options);

            google.maps.event.addDomListener(window, 'load', function () {
                var mapOptions = {
                    center: new google.maps.LatLng(settings.location.lat, settings.location.lng),
                    zoom: 12,
                    maxZoom: 16,
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                };

                _map = new google.maps.Map(document.getElementById(div), mapOptions);

                client.onEvent(receiveEvent);
            });
        }

        var receiveEvent = function (event) {
            if (!_map) return $(function () { receiveEvent(event); } );

            var item = _vehicles[event.VehicleId];

            if (!item)
                // Ignore
                return;

            if (event.Location && !isNaN(event.Location.Lat) && !isNaN(event.Location.Lng)) {
                setLocation(item, event.Location);

                // Follow selected Mojio or center on all
                if (_follow == event.VehicleId)
                    _map.panTo(item.location);
                else if (settings.autoCenter)
                    center();

            } else {
                // No location yet.  We can't place any new markers.
                if (!item.location) return;

                item.markers[item.markers.length] = new google.maps.Marker({
                    position: item.location,
                    map: _map,
                    title: event.EvenType
                });
            }
        }

        function setLocation(vehicle, location) {
            var latLng = new google.maps.LatLng(location.Lat, location.Lng);

            if (vehicle.path.length == 1) {
                var distance = google.maps.geometry.spherical.computeDistanceBetween(vehicle.location, latLng);
                if (distance > 500)
                    vehicle.path.clear();
            }
            // Push gps tracker line.
            vehicle.path.push(latLng);
            vehicle.location = latLng;

            if (!vehicle.marker)
                vehicle.marker = new google.maps.Marker({
                    position: latLng,
                    map: _map,
                    title: vehicle.data.Name
                });
            else
                vehicle.marker.setPosition(latLng);
        }

        function removeVehicle(vehicleId) {
            var item = _vehicles[vehicleId];

            if (!item)
                // Does not exist.
                return;

            for (var i = 0 ; i < item.markers.length ; i++)
                item.markers[i].setMap(null);

            if (item.marker)
                item.marker.setMap(null);

            item.poly.setMap(null);

            client.unsubscribe('Vehicle', vehicleId);

            _vehicles[vehicleId] = null;
        }

        function clearVehicles() {
            for (var k in _vehicles)
                removeVehicle( k );

            _vehicles = {};
        }

        function addVehicle(vehicle) {
            if (_vehicles[vehicle._id]) {
                return;
            }

            var polyOptions = {
                strokeColor: '#333333',
                strokeOpacity: 0.7,
                strokeWeight: 4
            }

            var poly = new google.maps.Polyline(polyOptions);
            poly.setMap(_map);

            _vehicles[vehicle._id] = {
                poly: poly,
                path: poly.getPath(),
                data: vehicle,
                location: null,
                marker: null,
                markers: []
            }

            if (vehicle.LastLocation && !isNaN(vehicle.LastLocation.Lat) && !isNaN(vehicle.LastLocation.Lng)) {
                setLocation(_vehicles[vehicle._id], vehicle.LastLocation);
            }
        }

        function subscribe(vehicleId, groups) {
            if (!groups)
                groups = Mojio.EventTypes;

            if (vehicleId) {
                client.subscribe("Vehicle", vehicleId, groups).fail(function () { $.error("Failed to subscribe"); });
            } else {
                var ids = [];
                for (var k in _vehicles) {
                    ids[ids.length] = k;
                }

                var test = client.subscribe('Vehicle', ids, groups);
            }
        }

        function addVehicleById(vehicleId) {
            return client.get('vehicles', vehicleId).done(addVehicle);
        }

        function center() {
            var bounds = new google.maps.LatLngBounds();

            for (var k in _vehicles)
            {
                if (_vehicles[k].location)
                    bounds.extend(_vehicles[k].location);
            }

            _map.fitBounds(bounds);
        }


        init(options);

        var public = {
            addVehicleById: addVehicleById,
            addVehicle: addVehicle,
            clearVehicles: clearVehicles,
            follow: function (id) { _follow = id; return this; },
            center: center,
            subscribe: subscribe
        };

        return public;
    }
})(jQuery);
