Ctrl = ($scope,$state,$timeout,$location,Invoice,Session,VendorQuote)->

  $scope.currentVendor = Session.get('currentVendor')
  $scope.quoteStatus = ''
  $scope.invoiceStatus = ''
  $scope.loading =
    quote: false
    invoice: false

  if !!$state.params.start && !!$state.params.end
    startDate = moment($state.params.start)
    endDate = moment($state.params.end)
  else
    startDate = moment().startOf('month')
    endDate = moment().endOf('month')

  $timeout ->
    cb = (start, end)->
      startDate = start
      endDate = end
      $scope.getQuotes($scope.quoteStatus)
      $scope.getInvoices($scope.invoiceStatus)
      label = (start.format('DD MMM YYYY') + ' - ' + end.format('DD MMM YYYY')).toUpperCase()
      $location.search(angular.extend(start: start.format('MM/DD/YYYY'), end: end.format('MM/DD/YYYY')))
      $('#rangepicker label').html(label + ' &nbsp; &rtrif;')
    $('#rangepicker').daterangepicker(
      locale:
        format: 'DD MMM YYYY'
      ranges: {
        'This Week': [moment().startOf('week').startOf('day'), moment().endOf('week').endOf('day')]
        'This Month': [moment().startOf('month').startOf('day'), moment().endOf('month').endOf('day')]
        'This Year': [moment().startOf('year').startOf('day'), moment().endOf('year').endOf('day')]
      }
    , cb)
    cb(startDate, endDate)

  $scope.invoiceClick = (event, invoice)->
    switch event.target.innerText.toLowerCase()
      when 'send a reminder'
        console.log 'TODO: send a reminder', invoice
      when 'cancel'
        console.log 'TODO: cancel', invoice
      else
        $state.go('vendor.payment', payment_id: invoice.attributes.invoice_no)

  $scope.quoteState =(status)->
    switch status
      when 'rejected' then 'declined'
      when 'offered' then 'raised'
      when 'fulfilled' then 'accepted'
      else
        status

  $scope.invoiceState =(status)->
    if status == 'unpaid' then 'sent' else status

  $scope.getQuotes =(status='')->
    $scope.quoteStatus = status
    $scope.loading.quote = true
    VendorQuote.query(vendor_uid: $scope.currentVendor.slug, status: $scope.quoteStatus, created_since: startDate.toISOString(), created_until: endDate.toISOString()).$promise.then (res)->
      $scope.quotes = res.data
      $scope.loading.quote = false

  $scope.getInvoices =(status='')->
    $scope.invoiceStatus = status
    $scope.loading.invoice = true
    Invoice.query(status: $scope.invoiceStatus, created_since: startDate.toISOString(), created_until: endDate.toISOString()).$promise.then (res)->
      $scope.invoices = res.data
      $scope.loading.invoice = false

  $scope.describeInvoice = (invoice)->
    if invoice.attributes.status == 'unpaid'
      "This invoice is pending payment"
    else
      "This invoice has been paid on #{moment(invoice.attributes.updated_at).format('DD MMM YYYY')}"
  $scope.describeQuote =(quote)->
    status = quote.attributes.status
    status = 'accepted' if quote.attributes.status == 'fulfilled'

    switch status
      when 'draft' then 'This quote is still on draft'
      when 'offered' then 'This quote is pending acceptance'
      when 'expired' then "This quote has expired on #{moment(quote.attributes.expires_at).format('DD MMM YYYY')}"
      when 'accepted' then "This quote has been #{status} on #{moment(quote.attributes.accepted_at).format('DD MMM YYYY')}"
      else
        stat = $scope.quoteState(status)
        "This quote has been #{stat} on #{moment(quote.attributes.updated_at).format('DD MMM YYYY')}"

  $scope.invoiceAddition = (obj)->
    "+ $#{parseFloat(obj.attributes.amount).toFixed(2)}"
  $scope.quoteAddition = (obj)->
    "+ $#{parseFloat(obj.attributes.fee.total).toFixed(2)}"

  $scope.getQuotes()
  $scope.getInvoices()

angular.module('client').controller('VendorTransactionCtrl', Ctrl)
