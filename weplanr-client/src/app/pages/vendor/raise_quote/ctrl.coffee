Ctrl = ($scope,$stateParams,$state,growl,Session,VendorQuote,$timeout)->
  $scope.currentVendor = currentVendor = Session.get('currentVendor')
  $scope.changed = no
  $scope.quote_items = []
  $scope.deposit = 0
  $scope.dueCost = 0
  $scope.formInvalid = false
  $scope.loading = false
  $scope.invalidCost = false

  userWeddingId =
    if $stateParams.weddingId
      localStorage.setItem('userWeddingId', $stateParams.weddingId)
      $stateParams.weddingId
    else
      localStorage.getItem('userWeddingId')

  $scope.weddingName = $stateParams.weddingName or localStorage.getItem('weddingName')
  localStorage.setItem('weddingName', $stateParams.weddingName) if $stateParams.weddingName

  weddingDate = $stateParams.weddingDate or localStorage.getItem('weddingDate')
  localStorage.setItem('weddingDate', weddingDate) if $stateParams.weddingDate

  $scope.services = currentVendor.pricing_and_packages
  $scope.quote_details =
    issue_date: moment().format('DD MMMM YYYY')
    expiry_date: moment().add(6, 'days').format('DD MMMM YYYY')
    name: currentVendor.business_name
    gst: if currentVendor.registered_for_gst then GST.INCLUSIVE else GST.EXCLUSIVE
  $scope.uiState =
    error: false
    draft: false

  dateFormat = 'DD/MM/YY'
  $scope.minDate = moment().add('day', 1)
  $scope.maxDate = moment().add('years', 5)

  VendorQuote.get(vendor_uid: currentVendor.slug, id: 'draft', wedding_id: userWeddingId).$promise
    .then (res)->
      return if res.data is null

      draft = res.data.attributes
      $scope.paymentDueDate =
        if draft.payment_due
          moment(draft.payment_due).format(dateFormat)
        else
          null
      $scope.deliveryDate =
        if draft.delivery_date
          moment(draft.delivery_date).format(dateFormat)
        else
          null
      idx = 0
      for item in draft.quote_items
        $scope.quote_items.push
          selService: $scope.services.find((obj)-> obj.name is item.name)
          name: item.name
          description: item.description
          quantity: item.quantity
          cost: parseFloat(item.cost).toFixed(2)
          total: parseFloat(item.total).toFixed(2)
        $scope.validateCost($scope.quote_items[idx], idx) if idx == 0
        idx++


    .finally ->
      $timeout(->
        flag1 = 0
        flag2 = 0
        flag3 = 0
        unwatcher1 = $scope.$watch('quote_items', ->
          if flag1 < 1
            flag1 += 1
          else
            $scope.changed = yes
            unwatcher1()
        , true)
        unwatcher2 = $scope.$watch 'paymentDueDate', ->
          if flag2 < 1
            flag2 += 1
          else
            $scope.changed = yes
            unwatcher2()
        unwatcher3 = $scope.$watch 'deliveryDate', ->
          if flag3 < 1
            flag3 += 1
          else
            $scope.changed = yes
            unwatcher3()
      )

  $scope.addNew = ->
    default_cost = 0
    default_cost = 1 if $scope.quote_items.length == 0
    $scope.quote_items.push {selService: '', name:'', description:'', quantity: 1, cost: default_cost, total: default_cost}

  $scope.removeService = (index)->
    $scope.quote_items.splice(index, 1)
    if index == 0
      $scope.validateCost($scope.quote_items[index], index)

  $scope.setService =(item,idx)->
    obj = $scope.quote_items[idx]
    price = parseFloat(item.price)
    obj.name = item.name
    obj.cost = price
    obj.total = calculateTax(price) * obj.quantity
    $scope.validateCost(obj, idx)

  $scope.changeCost =(price,idx)->
    obj = $scope.quote_items[idx]
    if price is null or price is undefined or price is "$"
      if idx == 0
        obj.cost = 1
        price = 1
      else
        obj.cost = 0
        price = 0
    else
      obj.cost =
        if price.replace
          parseFloat(price.replace(/[^\d|\-+|\.+]/g, ''))
        else
          price
    obj.total = calculateTax(obj.cost) * obj.quantity

  $scope.totalCost = ->
    total = 0
    for item in $scope.quote_items
      total += parseFloat(item.total)
    $scope.deposit = total * 0.4
    $scope.dueCost = total * 0.6
    total

  $scope.validateCost =(item,idx)->
    item['error'] = {}
    if item.cost < 1 && idx == 0
      $scope.invalidCost = true
      item['error']['cost'] = true
    else if item['error'] && item.cost > 0 && idx == 0
      $scope.invalidCost = false
      delete item['error']

  validateDate = (strDate, str) ->
    values = []
    values = strDate.split('/') if strDate isnt undefined
    if values.length isnt 3 or isNaN Date.parse("20#{values[2]}/#{values[1]}/#{values[0]}")
      growl.error("#{str} is invalid")
      return no
    return yes

  $scope.saveQuote =(form)->
    if form.$valid
      $scope.formInvalid = false
      $scope.loading = true
      return unless validateDate($scope.deliveryDate, 'Final Delivery Date')
      return unless validateDate($scope.paymentDueDate, 'Due Date')
      params =
        attributes:
          payment_due: moment($scope.paymentDueDate, 'DD/MM/YYYY').toISOString()
          delivery_date: moment($scope.deliveryDate, 'DD/MM/YYYY').toISOString()
          wedding_id: userWeddingId
          quote_items: $scope.quote_items
          status: 'offered'

      VendorQuote.save(vendor_uid:currentVendor.slug,data:params).$promise
        .then (response)->
          growl.success("Successfully generated quote")
          $state.go('vendor.messages')
        .catch (error)->
          $scope.loading = false
          growl.error("Unable to generate quote")
    else
      $scope.formInvalid = true


  $scope.saveDraft = ->
    return if $scope.deliveryDate and not validateDate($scope.deliveryDate, 'Final Delivery Date')
    return if $scope.paymentDueDate and not validateDate($scope.paymentDueDate, 'Final Delivery Date')
    params =
      attributes:
        payment_due: moment($scope.paymentDueDate, 'DD/MM/YYYY').toISOString()
        delivery_date: moment($scope.deliveryDate, 'DD/MM/YYYY').toISOString()
        wedding_id: userWeddingId
        quote_items: $scope.quote_items
        status: 'draft'

    VendorQuote.save(vendor_uid: currentVendor.slug, data: params).$promise
      .then (response)->
        $scope.uiState.draft = false
        growl.success("Successfully saved draft")
      .catch (error)->
        growl.error("Unable to save draft")

  calculateTax =(price)->
    return price unless currentVendor.registered_for_gst
    priceWithTax = price + (price * 0.10)

  $scope.populateDueDate = ->
    $timeout ->
      weeksBeforeDelivery = moment($scope.deliveryDate, 'DD/MM/YYYY').subtract(6, 'weeks')
      $scope.paymentDueDate =
        if weeksBeforeDelivery - moment() > 86400000 # if not today or before
          weeksBeforeDelivery.format(dateFormat)
        else
          null


angular.module('client').controller('RaiseQuoteCtrl', Ctrl)
