module = ->
  map = null
  defaultCenter = {lat: -33.865143, lng: 151.209900}
  {
    initMap: (id,center)->
      center  = if !!center then center else defaultCenter
      map = new (google.maps.Map)(document.getElementById(id),
        zoom: 12
        panControl: false
        zoomControl: true
        zoomControlOptions:
          style: google.maps.ZoomControlStyle.DEFAULT,
          position: google.maps.ControlPosition.LEFT_CENTER
        mapTypeControl: true
        scaleControl: false
        draggable: false
        center: center)
      map
  }

angular.module('client').factory('Gmap', module)
