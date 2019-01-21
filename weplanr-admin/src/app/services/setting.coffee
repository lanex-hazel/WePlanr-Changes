module = ->

  {
    locationOpt: ->
      [
        "Blue Mountains",
        "Central Coast",
        "Explorer Country",
        "Illawarra",
        "Inner West",
        "Lord Howe Island",
        "Murray Riverina",
        "New England",
        "Norfolk Island",
        "North Coast",
        "Northern Rivers and Byron Bay",
        "NSW Outback",
        "Port Stephens",
        "Snowy Mountains",
        "South Coast",
        "Southern Highlands",
        "Sydney"
      ]

    socialOpt: ->
      [
        "facebook",
        "instagram",
        "pinterest",
        "twitter",
        "vimeo",
        "youtube"
      ]
  }

angular.module('client').factory('Setting', module)
