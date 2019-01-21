Ctrl = ($scope,$state,growl,LoadData,Session,Earning)->
  $scope.currentVendor = Session.get('currentVendor')

  Earning.query().$promise.then (res)->
    $scope.totals = res.data

  $scope.formatAmount = (amount)->
    if amount
      parseFloat(amount).toFixed(2)
    else
      0.toFixed(2)

  $scope.months = LoadData.getMonth()
  $scope.selectedMonth = $scope.months[new Date().getMonth()].id

  $scope.updateGraph = ->
    Earning.query(month: $scope.selectedMonth, year: new Date().getFullYear()).$promise.then (res)->
      #stats =
        #'5 Jul':  "900.0"
        #'10 Jul': "600.0"
        #'15 Jul': "200.0"
        #'20 Jul': "500.0"
        #'25 Jul': "800.0"
        #'30 Jul': "800.0"
      stats = res.data.earnings
      # Graphs is ugly on 1 data
      if Object.keys(stats).length is 1
        firstKey = Object.keys(stats)[0]
        month = firstKey.match(/\d+ (\D+)/)[1]
        day = parseInt(firstKey)
        orig = angular.copy(stats)
        stats = {}
        if day is 1
          stats["#{if month is 'Feb' then 28 else 30} #{month}"] = 0
        else
          stats["1 #{month}"] = 0
        angular.merge(stats, orig)

      values = Object.keys(stats).map((key)-> parseFloat(stats[key]).toFixed(2))

      ctx = document.getElementById('earnings-analytics')
      chart = new Chart ctx,
        type: 'line'
        data:
          labels: Object.keys(stats).map((key)-> parseInt(key))
          fill: no
          showBottomGuide: yes
          bottomGuideDistance: 9
          datasets: [{
            label: ''
            lineTension: 0
            data: values
            backgroundColor: 'rgba(0,0,0,0)'
            borderColor: 'rgb(240,198,204)'
            borderWidth: 2
            pointBorderColor: 'rgb(206,66,87)'
            pointBackgroundColor: 'white'
            pointBorderWidth: 2
            pointRadius: 4
            spanGaps: no
          }]
        options:
          legend: display: no
          layout: padding: right: 6
          scales:
            gridLines: showBorder: no
            xAxes: [{
              gridLines:
                color: 'rgba(255,255,255,0)'
                zeroLineColor: 'rgba(255,255,255,0)'
                tickMarkLength: 57
              ticks:
                fontColor: '#999'
                fontSize: 14
            }]
            yAxes: [{
              gridLines:
                drawBorder: no
                color: 'rgb(245,245,245)'
              ticks:
                beginAtZero: Math.max.apply(null, values) is 0
                fontColor: '#999'
                fontSize: 14
                fontWeight: '500'
                padding: 14
                userCallback: (label, index, labels)->
                  # when the floored value is the same as the value we have a whole number
                  if Math.floor(label) is label then label
            }]


  $scope.updateGraph()

angular.module('client').controller('VendorEarningsCtrl', Ctrl)
