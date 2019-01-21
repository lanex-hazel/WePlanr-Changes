angular.module('client').filter 'exclude', (filterFilter) ->
  (input, filterEach, exclude) ->
    filterEach.forEach (item) ->
      if angular.equals(item, exclude)
        return
      input = filterFilter(input, '!' + item)
      return
    input

separateNum =(val)->
  val.toString().split('').reverse().join('').replace(/(.{1,3})/g, '$1 ').trim().split('').reverse().join('') if val?

angular.module('client').filter 'priceDisplay', ->
  (val) ->
    '$ ' + separateNum(val)

angular.module('client').filter 'numDisplay', ->
  (val) ->
    separateNum(val)

angular.module('client').filter 'capitalize', ->
  (string)->
    string.charAt(0).toUpperCase() + string.slice(1) if string

angular.module('client').filter 'capitalizeAll', ->
  (string)->
    string.replace(/\b\w/g, (word)-> word.toUpperCase() ) if string

angular.module('client').filter 'fileFormat', ->
  (val) ->
    val.replace(' ', '_')

weekday = new Array(7)
weekday[0] = 'Sun'
weekday[1] = 'Mon'
weekday[2] = 'Tue'
weekday[3] = 'Wed'
weekday[4] = 'Thu'
weekday[5] = 'Fri'
weekday[6] = 'Sat'
angular.module('client').filter 'chatTime', ->
  (strDate) ->
    ref = moment(new Date)
    today = ref.clone().startOf('day')
    lastWeek = ref.clone().subtract(7, 'days').startOf('day')
    momentDate = moment(strDate)

    if momentDate.isSame(today, 'd')
      momentDate.format('H:mm')
    else if momentDate.isAfter(lastWeek)
      weekday[momentDate.diff(moment().startOf('week'),'days')]
    else
      momentDate.format('D MMM').toLowerCase()

angular.module('client').filter 'russianNum', ->
  (val)->
    return 0 unless val
    strNum = (String(val).match(/\d+(\.\d+)?/g, '') or [0])[0]
    Number(strNum).toLocaleString('ru-RU').replace(',', '.')

angular.module('client').filter 'parseInt', ->
  (val)->
    if val then parseInt(val) else 0

angular.module('client').filter 'dollarNum', ->
  (val, decimals)->
    return 0 unless val
    strNum = (String(val).match(/\d+(\.\d+)?/g, '') or [0])[0]
    strNum = "-#{strNum}" if Number(val) < 0
    num = if decimals then Number(strNum).toFixed(decimals) else Math.round(Number(strNum))
    strNum = num.toLocaleString('ru-RU').replace(',', '.')
    "$ #{strNum}"

angular.module('client').filter 'moneyFormat', ->
  (val)->
    return "$0" unless val
    strNum = String(val).replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,")
    "$#{strNum}"

angular.module('client').filter 'statusSort', ->
  (items, field, value) ->
    overduegroup = []
    firstgroup = []
    secondgroup = []
    lastgroup = []
    angular.forEach items, (item) ->
      if (value <= item.attributes.timing_max_month && value >= item.attributes.timing_min_month)
        firstgroup.push item
      else if !(item.attributes.timing_max_month <= value && value >= item.attributes.timing_min_month) && ( item.status == 'booked' || item.status == 'removed')
        lastgroup.push item
      else if item.attributes.overdue > value
        item.status = 'overdue' if item.status == 'pending'
        overduegroup.push item
      else
        secondgroup.push item
    return overduegroup.concat(firstgroup).concat(secondgroup).concat(lastgroup)

angular.module('client').filter 'groupTodo', ->
  (items) ->
    returnItems = []
    tempItems = []
    angular.forEach items, (item) ->
      if (tempItems.indexOf(item.attributes.name) == -1)
        tempItems.push item.attributes.name
        returnItems.push item
    return returnItems

angular.module('client').filter 'statusOverdue', ->
  (items, value) ->
    collection = []
    angular.forEach items, (item) ->
      if item.attributes.timing_min_month > value
        collection.push item if item.attributes.status == 'pending'
    return collection

