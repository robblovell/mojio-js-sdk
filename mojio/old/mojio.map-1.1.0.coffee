
module.exports = class MojioMap
    constructor: (div, client, options) ->
        @vehicle = {}
        @map = null
        @follow = null
        @settings = null
        @client = client
        @div = div
        @settings = $.extend({
            'template': '#eventTemplate',
            'delay': 800,
            'autoCenter': true,
            'location': { lat: 49.278277, lng: -123.116977 }
        }, options)
        google.maps.event.addDomListener(window, 'load', () ->
            mapOptions = {
                center: new google.maps.LatLng(settings.location.lat, settings.location.lng),
                zoom: 12,
                maxZoom: 16,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            }
            @map = new google.maps.Map(document.getElementById(div), mapOptions)

            @client.onEvent(receiveEvent)
        )

    receiveEvent: (event) =>
        if (!_map)
            return $(() -> receiveEvent(event))

        item = @vehicles[event.VehicleId];

        return if (!item) # Ignore

        if (event.Location && !isNaN(event.Location.Lat) && !isNaN(event.Location.Lng))
            setLocation(item, event.Location)

            # Follow selected Mojio or center on all
            if (_follow == event.VehicleId)
                _map.panTo(item.location)
            else if (settings.autoCenter)
                center()
            else
                # No location yet.  We can't place any new markers.
                return if (!item.location)

                item.markers[item.markers.length] = new google.maps.Marker({
                    position: item.location,
                    map: _map,
                    title: event.EvenType
                });

    setLocation: (vehicle, location) ->
        latLng = new google.maps.LatLng(location.Lat, location.Lng);

        if (vehicle.path.length == 1)
            distance = google.maps.geometry.spherical.computeDistanceBetween(vehicle.location, latLng)
            vehicle.path.clear() if (distance > 500)

        # Push gps tracker line.
        vehicle.path.push(latLng)
        vehicle.location = latLng

        if (!vehicle.marker)
            vehicle.marker = new google.maps.Marker({
                position: latLng,
                map: _map,
                title: vehicle.data.Name
            })
        else
            vehicle.marker.setPosition(latLng)


    removeVehicle: (vehicleId) ->
        item = _vehicles[vehicleId];

        return if (!item) # Does not exist.

        for i in [0..item.markers.length]
            item.markers[i].setMap(null)

        if (item.marker)
            item.marker.setMap(null)

        item.poly.setMap(null)

        client.unsubscribe('Vehicle', vehicleId)

        @vehicles[vehicleId] = null


    clearVehicles: () ->
        for k in @vehicles
            removeVehicle( k )

        _vehicles = {}


    addVehicle: (vehicle) ->
        if (_vehicles[vehicle._id])
            return


        polyOptions = {
            strokeColor: '#333333',
            strokeOpacity: 0.7,
            strokeWeight: 4
        }

        poly = new google.maps.Polyline(polyOptions)
        poly.setMap(_map)

        @vehicles[vehicle._id] = {
            poly: poly,
            path: poly.getPath(),
            data: vehicle,
            location: null,
            marker: null,
            markers: []
        }

        if (vehicle.LastLocation && !isNaN(vehicle.LastLocation.Lat) && !isNaN(vehicle.LastLocation.Lng))
            setLocation(_vehicles[vehicle._id], vehicle.LastLocation)

    subscribe: (vehicleId, groups) ->
        if (!groups)
            groups = Mojio.EventTypes

        if (vehicleId)
            client.subscribe("Vehicle", vehicleId, groups).fail(() -> $.error("Failed to subscribe"))
        else
            ids = [];
            for k in _vehicles
                ids[ids.length] = k

            test = @client.subscribe('Vehicle', ids, groups);

    addVehicleById: (vehicleId) ->
            return @client.get('vehicles', vehicleId).done(addVehicle)

    center: () ->
        bounds = new google.maps.LatLngBounds()

        for k in _vehicles
            if (_vehicles[k].location)
                bounds.extend(_vehicles[k].location)

        @map.fitBounds(bounds)
