Ctrl = ($rootScope,$scope,$state,growl,VendorQuote,BankCard,Vendor,Organisr,Todo,Service,Session)->
  $scope.currentUser = Session.get('currentUser')
  $scope.returnTo = $state.params.returnTo or 'user.todo_list'
  vendorId = $state.params.vendor_slug or 'na'
  quoteNo = $state.params.no
  budget = {}
  $scope.loading = false
  params = []
  booking_id = null
  invoiceNo = null
  $scope.selectedTodo = null
  $scope.todoError = false
  $scope.form = {}
  primary_service_id = null
  $scope.services = []
  $scope.uiState =
    createTodoModal: false
    selectTodoModal: false

  VendorQuote.get(vendor_uid: vendorId, id: quoteNo).$promise
    .then (res)->
      $scope.obj = res.data # for payment view
      $scope.quote = res.data.attributes
      $scope.discount = Number(res.data.attributes.discount)
      amounts = _(res.data.attributes.quote_items).map('total')
      $scope.quoteTotal = _(amounts).reduce(((sum, num)-> sum + Number(num)), 0)
      $scope.deposit = $scope.quoteTotal * .4
      $scope.dueCost = $scope.quoteTotal * .6
      $scope.expiryDate = moment($scope.quote.updated_at).add(6, 'days').format('DD MMMM YYYY')
      $scope.gstNotice = if res.data.attributes.is_gst then GST.INCLUSIVE else GST.EXCLUSIVE
      budget =
        actual: $scope.quoteTotal
        paid: $scope.deposit

  BankCard.query().$promise.then (res)->
    $scope.bankCards = res.data

  Todo.query(include_removed: true).$promise.then (res)->
    $scope.items = res.data

  getServices = ->
    Service.getList(primary: true).$promise.then (res)->
      $scope.services = res.data
      $scope.services.push {id: null, attributes: name: 'Others'}

  getCategories = ->
    Service.categories().$promise.then (res)->
      $scope.categories = res.data

  if vendorId isnt 'na'
    Vendor.get(vendor_uid: vendorId).$promise.then (res)->
      vendor_services = _.union(res.data.attributes.primary_services, res.data.attributes.secondary_services)
      Todo.query('services[]': vendor_services).$promise.then (res)->
        $scope.todos = res.data.filter (obj) -> obj.attributes.status == 'pending'
  getServices()

  $scope.book = ->
    if $scope.bankCards.length < 1
      $scope.showNewCard = yes
    else
      $scope.uiState.selectTodoModal = yes

  $scope.payNow = ->
    $scope.loading = on
    type = "todos"
    VendorQuote.accept(vendor_id: vendorId, id: quoteNo).$promise
      .then (res)->
        growl.success('Payment Successful')
        obj = res.data.attributes
        booking_id = obj.booking.id
        invoiceNo =
          if obj.status == 'accepted'
            obj.invoices.deposit
          else if obj.status == 'fulfilled' && !!obj.invoices.full
            obj.invoices.full
          else
            obj.invoices.due
        type = "custom_todos" if $scope.selectedTodo.type == "Organisr::CustomTodo"
        $scope.uiState.selectTodoModal = false
        $scope.uiState.createTodoModal = false
        Organisr.updateBooking(todo_id: $scope.selectedTodo.attributes.id, type: type, id: booking_id).$promise
          .finally ->
            $scope.loading = no
            $state.go('user.payment', no: invoiceNo)

  $scope.payFull = ->
    swal(
      text: "ARE YOU SURE YOU WANT TO PAY #{$scope.obj.attributes.vendor.business_name} IN FULL? "
      type: 'warning'
      showCancelButton: true
      confirmButtonText: 'Yes'
      cancelButtonText: 'No'
      closeOnCancel: true
      closeOnConfirm: true
    ).then (confirmed) ->
      return unless confirmed
      $scope.loading = on
      VendorQuote.fulfill(vendor_id: vendorId, id: quoteNo).$promise
        .then (res)->
          $scope.obj = res.data
          growl.success('Payment Successful')
        .finally ->
          $scope.loading = no

  $scope.reject = ->
    $scope.loading = on
    VendorQuote.reject(vendor_id: vendorId, id: quoteNo).$promise
      .then (res)->
        growl.success("Quote successfully declined.")
        $state.go('user.messages')
      .finally -> $scope.loading = no

  $scope.showNewCard = no
  $scope.cardSave = ->
    $scope.uiState.selectTodoModal = yes
    $scope.showNewCard = no
  $scope.cardCancel = ->
    $scope.showNewCard = no

  ## Link Todo
  $scope.toggleModal = ->
    $scope.uiState.selectTodoModal = false
    $scope.uiState.createTodoModal = true

  $scope.addItem =(obj)->
    Organisr.addItem(data: attributes: obj).$promise
      .then (res) ->
        $scope.selectedTodo = res.data
        $scope.selectedTodo.type = "Organisr::CustomTodo"
        $scope.payNow()

  $scope.createParams =(todo)->
    $scope.selectedTodo = todo


angular.module('client').controller('QuoteCtrl', Ctrl)

