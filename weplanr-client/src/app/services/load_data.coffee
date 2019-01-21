module = ->

  month = [
    {id: "01", name: "January"},
    {id: "02", name: "February"},
    {id: "03", name: "March"},
    {id: "04", name: "April"},
    {id: "05", name: "May"},
    {id: "06", name: "June"},
    {id: "07", name: "July"},
    {id: "08", name: "August"},
    {id: "09", name: "September"},
    {id: "10", name: "October"},
    {id: "11", name: "November"},
    {id: "12", name: "December"}
  ]
  {
    getMonth: ->
      return month
    getYear: ->
      year = (new Date).getFullYear()
      range = []
      range.push year
      i = 1
      while i < 7
        range.push (year + i).toString()
        i++
      years = range
    getDay: (total_days=31)->
      range = []
      i = 1
      while i <= total_days
        if i < 10
          range.push "0" + i
        else
          range.push i.toString()
        i++
      days = range
  }
angular.module('client').factory('LoadData', module)
