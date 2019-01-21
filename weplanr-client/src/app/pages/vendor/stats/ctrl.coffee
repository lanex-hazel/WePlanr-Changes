Ctrl = ($scope,$state,growl,User,Session,MyVendor,$timeout)->
  $scope.currentVendor = Session.get('currentVendor')
  $scope.loading = yes
  chart = null
  vendorId = $state.params.slug
  $scope.dateMaxLimit = (new Date((new Date().getFullYear()) + 3, (new Date().getMonth()) + 1, 0)).toString()

  startDate = moment().startOf('month')
  endDate = moment().endOf('month')
  $timeout ->
    cb = (start, end)->
      startDate = start
      endDate = end
      $scope.updateStats()
      label = (start.format('DD MMM YYYY') + ' - ' + end.format('DD MMM YYYY')).toUpperCase()
      $('#rangepicker label').html(label + ' &nbsp; &rtrif;')
    $('#rangepicker').daterangepicker(
      locale:
        format: 'DD MMM YYYY'
      ranges: {
        #'Today': [moment().startOf('day'), moment().endOf('day')]
        'This Week': [moment().startOf('week').startOf('day'), moment().endOf('week').endOf('day')]
        'This Month': [moment().startOf('month').startOf('day'), moment().endOf('month').endOf('day')]
        'This Year': [moment().startOf('year').startOf('day'), moment().endOf('year').endOf('day')]
      }
    , cb)
    cb(startDate, endDate)

  $scope.updateStats = ->
    return unless vendorId
    $scope.loading = yes
    MyVendor.getStats(id: vendorId, start_date: startDate.toISOString(), end_date: endDate.toISOString()).$promise
      .then (res) ->
        $scope.bookings = res.data.totals.bookings
        $scope.inquiries = res.data.totals.inquiries
        $scope.views = res.data.totals.views
        $scope.favorites = res.data.totals.favorites
        views = res.data.views

        msDiff = endDate.diff(startDate)
        noOfDays = Math.ceil(moment.duration(msDiff).asDays())

        data = {}
        ipByDays = {}

        if noOfDays > 98 # monthly view for > 98 days / 14 weeks
          data[moment(startDate).startOf('year').format('MMM')] = []
          for obj in views
            month = moment(obj.created_at).local().format('MMM')
            day = moment(obj.created_at).local().format('D MMM')
            continue if ipByDays[day] and obj.ip_address in ipByDays[day]
            prevMonth = Object.keys(data).pop()
            nextMonth = moment(prevMonth, 'MMM').add(1, 'M').format('MMM')
            while month isnt nextMonth and month isnt prevMonth
              data[nextMonth] = []
              nextMonth = moment(nextMonth, 'MMM').add(1, 'M').format('MMM')
            data[month] ?= []
            data[month].push(obj.ip_address)
            ipByDays[day] ?= []
            ipByDays[day].push(obj.ip_address)
          endLabel = moment(endDate).format('MMM')
          until endLabel is Object.keys(data).pop()
            nextMonth = moment(Object.keys(data).pop(), 'MMM').add(1, 'M').format('MMM')
            data[nextMonth] = []

        else if noOfDays > 14 # weekly view for > 14 days
          firstLabel = moment(startDate).startOf('week').format('D MMM') + ' - ' + moment(startDate).endOf('week').format('D MMM')
          data[firstLabel] = []
          for obj in views
            week = moment(obj.created_at).local().startOf('week').format('D MMM') + ' - ' + moment(obj.created_at).local().endOf('week').format('D MMM')
            day = moment(obj.created_at).local().format('D MMM')
            continue if ipByDays[day] and obj.ip_address in ipByDays[day]
            prevWeek = Object.keys(data).pop()
            nextWeekDate = moment(prevWeek.split(' - ')[0], 'D MMM').add(1, 'w')
            nextWeekLabel = nextWeekDate.startOf('week').format('D MMM') + ' - ' + nextWeekDate.endOf('week').format('D MMM')
            while week isnt nextWeekLabel and week isnt prevWeek
              data[nextWeekLabel] = []
              nextWeekDate = moment(nextWeekDate, 'MMM').add(1, 'w')
              nextWeekLabel = nextWeekDate.startOf('week').format('D MMM') + ' - ' + nextWeekDate.endOf('week').format('D MMM')
            data[week] ?= []
            data[week].push(obj.ip_address)
            ipByDays[day] ?= []
            ipByDays[day].push(obj.ip_address)
          endLabel = moment(endDate).local().startOf('week').format('D MMM') + ' - ' + moment(endDate).local().endOf('week').format('D MMM')
          until endLabel is Object.keys(data).pop()
            nextWeekDate = moment(Object.keys(data).pop().split(' - ')[0], 'D MMM').add(1, 'w')
            nextWeekLabel = nextWeekDate.startOf('week').format('D MMM') + ' - ' + nextWeekDate.endOf('week').format('D MMM')
            data[nextWeekLabel] = []

        else # day view
          data[moment(startDate).format('D MMM')] = []
          for obj in views
            day = moment(obj.created_at).local().format('D MMM')
            continue if ipByDays[day] and obj.ip_address in ipByDays[day]
            prevDay = Object.keys(data).pop()
            nextDay = moment(prevDay, 'D MMM').add(1, 'd').format('D MMM')
            while day isnt nextDay and day isnt prevDay
              data[nextDay] = []
              nextDay = moment(nextDay, 'D MMM').add(1, 'd').format('D MMM')
            data[day] ?= []
            data[day].push(obj.ip_address)
            ipByDays[day] ?= []
            ipByDays[day].push(obj.ip_address)
          endLabel = moment(endDate).format('D MMM')
          until endLabel is Object.keys(data).pop()
            nextDay = moment(Object.keys(data).pop(), 'D MMM').add(1, 'd').format('D MMM')
            data[nextDay] = []

        labels = []; values = []
        for key, val of data
          labels.push key.toUpperCase()
          values.push val.length
        ctx = document.getElementById('profile-view-analytics')

        # TODO fix styling on weekly view
        #      y-axis height is dynamic and pushing bottom guide dots to invi area
        chart.destroy() if chart # fix reloading of previous graphs
        chart = new Chart(ctx,
          type: 'line'
          data:
            labels: labels
            fill: no
            #showBottomGuide: yes
            #bottomGuideDistance: 14
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
                #display: no
                gridLines:
                  color: 'rgba(255,255,255,0)'
                  zeroLineColor: 'rgba(255,255,255,0)'
                ticks:
                  fontColor: 'rgba(255,255,255,0)'
                  fontSize: if labels[0].length > 6 then 8 else 24
              }]
              yAxes: [{
                gridLines:
                  drawBorder: no
                  zeroLineColor: 'rgb(230,230,230)'
                ticks:
                  beginAtZero: Math.max.apply(null, values) is 0
                  #max: Math.max.apply(null, values.concat([8]))
                  fontColor: 'rgb(230,230,230)'
                  fontSize: 14
                  fontStyle: 'bold'
                  padding: 14
                  userCallback: (label, index, labels)->
                    # when the floored value is the same as the value we have a whole number
                    if Math.floor(label) is label then label
              }]
        )
      .finally ->
        $scope.loading = no


  unless vendorId
    MyVendor.getList().$promise.then (response)->
      vendorId = response.data[0].attributes.slug
      Session.set('currentVendor', response.data[0].attributes)
      $scope.currentVendor = Session.get('currentVendor')
      $scope.updateStats()

angular.module('client').controller('VendorStatsCtrl', Ctrl)
