Ctrl = ($scope,$state,growl,Organisr,Tag,Todo,Session,Service,User)->

  $scope.currentUser = Session.get('currentUser')
  $scope.maxBudget = $scope.currentUser.wedding_details.budget
  weddingDate = $scope.currentUser.wedding_details.date
  $scope.remainingMonths = moment(weddingDate).diff(moment(moment().format('YYYY-MM-DD')), 'months')
  if !weddingDate then $scope.remainingMonths = 18
  $scope.name =
    if $scope.currentUser?.partner
      $scope.currentUser.firstname + " and " + $scope.currentUser.partner.firstname
    else
      'Bride and Groom'

  $scope.column = [false,false,true,true]
  $scope.currentColumn = 0
  $scope.loading = false
  $scope.uiState =
    view: 'category'
    addModal: false
    removeModal: false
    vendorForm: false
    formType: ''
    filter: 'all'
    query: null
    tab: "overview"
    suggesting: false
    order: false
    addNotes: false

  $scope.services = []
  $scope.suggestedTags = []
  $scope.currentVendor = null
  $scope.selectedItem = null
  $scope.removedItems = []
  $scope.completed = 0
  $scope.pending = 0

  resetTotals = ->
    $scope.totalPlanned = 0
    $scope.totalGuide = 0
    $scope.totalPlannedDiff = 0
    $scope.totalActual = 0
    $scope.totalPaid = 0
    $scope.totalOwing = 0
  resetTotals()

  calculateDiffsAndTotals = ->
    resetTotals()
    for item in $scope.unremoveItems
      item.attributes.actual = parseInt(item.attributes.actual)
      item.attributes.paid = parseInt(item.attributes.paid)
      $scope.totalPlanned += item.attributes.planned
      $scope.totalActual += item.attributes.actual
      $scope.totalPaid += item.attributes.paid

      item.attributes.owing = item.attributes.actual - item.attributes.paid
      $scope.totalOwing += item.attributes.owing

    for item in $scope.filterItems
      for obj in item.items
        obj.attributes.actual = parseInt(obj.attributes.actual)
        obj.attributes.paid = parseInt(obj.attributes.paid)
        obj.attributes.owing = obj.attributes.actual - obj.attributes.paid

  getServices = ->
    Service.getList(primary: true).$promise.then (res)->
      $scope.services = res.data
      $scope.services.push {id: null, attributes: name: 'Others'}

  getItems =(showLoading=true)->
    $scope.loading = true if showLoading
    Organisr.query().$promise
      .then (res) ->
        $scope.items = res.data
        $scope.unremoveItems = angular.copy(res.data).filter( (obj) -> obj.attributes.status == 'booked' or obj.attributes.status == 'pending')
        $scope.filterItems = angular.copy res.data
        $scope.completed = $scope.items.filter( (obj) -> obj.attributes.status == 'booked').length
        $scope.pending = $scope.items.filter( (obj) -> obj.attributes.status == 'pending').length
        $scope.removed = $scope.items.filter( (obj) -> obj.attributes.status == 'removed').length
        $scope.itemCnt = res.data.length - $scope.removed
      .finally ->
        $scope.loading = false
        $scope.filterStatus()
        calculateDiffsAndTotals()

  getItems()
  getServices()

  $scope.fetchTags =(params)->
    $scope.uiState.suggesting = true
    Tag.searchTag(q: params).$promise.then (res)->
      $scope.suggestedTags = res.data
    .finally ->
      $scope.uiState.suggesting = false

  $scope.currencyFormat =(num)->
    "$" + num.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,")

  $scope.navigate =(direction)->
    $scope.column[$scope.currentColumn] = true
    $scope.column[$scope.currentColumn+1] = true

    if direction && $scope.currentColumn < 2
      $scope.currentColumn += 2
    else if !direction && $scope.currentColumn > 0
      $scope.currentColumn -= 2

    $scope.column[$scope.currentColumn] = false
    $scope.column[$scope.currentColumn+1] = false

  $scope.changeView =(view)->
    $scope.uiState.view = view
    $scope.uiState.order = view == 'timeline'
    $scope.filterStatus()

  $scope.changeFilter =(filter)->
    $scope.uiState.filter = filter
    $scope.filterStatus()

  $scope.toggleVendorForm =(obj,mode)->
    $scope.uiState.formType = mode
    if mode == ''
      $scope.uiState.vendorForm = false
    else
      $scope.selectedItem = obj
      $scope.uiState.vendorForm = true

  $scope.toggleRemoveModal =(obj)->
    $scope.uiState.removeModal = true
    $scope.selectedItem = obj

  $scope.toggleNoteModal =(obj,enable)->
    $scope.uiState.addNotes = enable
    $scope.selectedItem = obj

  $scope.saveBudget =(budget)->
    params = wedding_details: budget: Number(budget)
    User.update(data: attributes: params).$promise
      .then (res)->
        Session.set('currentUser',res.data.attributes)
        $scope.currentUser = Session.get('currentUser')
        $scope.maxBudget = $scope.currentUser.wedding_details.budget
        getItems()
        growl.success(MESSAGES.UPDATE_SUCCESS)

  $scope.addItem =(obj)->
    Organisr.addItem(data: attributes: obj).$promise
      .then (res) ->
        $scope.uiState.addModal = false
        getItems()

  $scope.removeItem =(obj)->
    type = 'budgets'
    type = 'custom_todos' if obj.type == 'Organisr::CustomTodo'
    Organisr.removeItem(type: type, id: obj.attributes.id).$promise.finally ->
      getItems()
      $scope.toggleVendorForm(null, '') if $scope.uiState.formType != ''

  $scope.restoreItem =(id)->
    Organisr.restoreItem(id: id).$promise.finally ->
      $scope.changeFilter('all')
      getItems()

  $scope.updatePlanned =(obj) ->
    type = 'budgets'
    type = 'custom_todos' if obj.type == 'Organisr::CustomTodo'

    params = { planned: parseNum(obj.attributes.planned) }
    Organisr.updateItem(type: type, id: obj.attributes.id, data: attributes: params).$promise.finally ->
      getItems(false)
      $(document.body).find('div.growl-container').addClass('growl-custom')
      growl.success("Successfully saved.")

  $scope.addVendor =(obj,params)->
    if obj.type == 'Organisr::CustomTodo'
      params.custom_todo_id = obj.attributes.id
    else
      params.budget_id = obj.attributes.id
    Organisr.addVendor(data: attributes: params).$promise.then (res)->
      $scope.toggleVendorForm(null, '')
      getItems()

  $scope.updateVendor =(obj,params)->
    Organisr.updateVendor(id: params.id, data: attributes: params).$promise.then (res)->
      $scope.toggleVendorForm(null, '')
      getItems()

  $scope.saveNotes =(obj,params)->
    Todo.saveNote(id: obj.id, data: attributes: params).$promise
      .then (res)->
        console.log 'update notes'
        getItems(false)
        return true
      .catch (err)->
        return false

  parseNum = (val)->
    strNum = String(val).replace(/[\D\s]+/g, '')
    Number(strNum)

  $scope.filterStatus = ->
    overdue = []
    $scope.filterItems = angular.copy $scope.items
    collection = $scope.filterItems
    removed = angular.copy $scope.items
    status = $scope.uiState.filter

    removed = removed.filter((obj) -> obj.attributes.status == 'removed')
    collection = collection.filter((obj) -> obj.attributes.status == status) if status != 'all' && (status != 'overdue' && status != 'removed')
    collection = collection.filter((obj) -> obj.attributes.status != 'removed')

    $scope.removedItems = groupBy(removed)
    # if status == 'overdue'
    angular.forEach(collection, (item) ->
      if item.attributes.timing_min_month > $scope.remainingMonths
        if item.attributes.status == 'pending'
          item.attributes.status = 'overdue'
          overdue.push item
    )
    return $scope.filterItems = groupBy(overdue) if status == 'overdue'
    return $scope.filterItems = groupBy(collection)

  groupBy =(items)->
    groups = items.reduce(((obj, item) ->
      item.attributes.actual = parseInt(item.attributes.actual)
      item.attributes.paid = parseInt(item.attributes.paid)
      if $scope.uiState.view == 'category'
        if item.attributes.category?
          key = JSON.stringify(item.attributes.category)
        else
          key = JSON.stringify({order_rank: null, name: 'Others'})
      else
        key = JSON.stringify({order_rank: item.attributes.timing_min_month, name: "#{item.attributes.timing_max_month}-#{item.attributes.timing_min_month} MONTHS BEFORE THE WEDDING"})
        key = JSON.stringify({order_rank: 0, name: "no timeline"}) if item.attributes.timing_max_month == null
      obj[key] = obj[key] or []
      obj[key].push item
      obj
    ), {})

    myArray = Object.keys(groups).map (key) ->
      {
        label: JSON.parse(key)
        items: groups[key]
      }
    return myArray

  $scope.openModal =(val)->
    $scope.uiState.addModal = val
    if val
      $(document.body).addClass("modal-open")
    else
      $(document.body).removeClass("modal-open")

angular.module('client').controller('UserOrganiserCtrl', Ctrl)
