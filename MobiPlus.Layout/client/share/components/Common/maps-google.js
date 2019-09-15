// Google Maps
// -----------------------------------

export default function (mapData) {

    if (!$.fn.gMap) return;
    // $("#map").gMap();
    let gMapRefs = [];
    let lat, lng;

    if(mapData){
        var $this = $(this),
            trucksArr = mapData.mapTruckData || [],
            visitsArr = mapData.mapVisitData || [],
            roadsArr = $this.data('roads') || [],
            zoom = $this.data('zoom') || 9,
            maptype = $this.data('maptype') || 'ROADMAP', // or 'TERRAIN'
            markers = [];

        if (trucksArr.length>0) {
            for (var i in trucksArr) {
                markers.push({
                    latitude: trucksArr[i].DriverGPSLocation.Lat || '',
                    longitude: trucksArr[i].DriverGPSLocation.Lng || '',
                    icon: {
                        image: "../../../public/img/truck2.png",
                        iconsize: [60, 80],
                        iconanchor: [12, 46]
                    },
                    html: trucksArr[i].DriverGPSLocation.Comment || '',
                    popup: false 
                });
                lat = trucksArr[i].DriverGPSLocation.Lat || '';
                lng = trucksArr[i].DriverGPSLocation.Lng || '';
            } 
        } 

    }
    var options = {
        controls: {
            panControl: true,
            zoomControl: true,
            mapTypeControl: true,
            scaleControl: true,
            overviewMapControl: true
        },
        scrollwheel: true,
        maptype: maptype,
        markers: markers,
        zoom: zoom,
        latitude: lat,
        longitude: lng
    };
    var gMap = $this.gMap(options);

    var ref = gMap.data('gMap.reference');
    // save in the map references list
    gMapRefs.push(ref);

    
} //initGmap
