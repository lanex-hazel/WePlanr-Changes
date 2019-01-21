Ctrl = ->
  ctrl = this

  ctrl.$onInit = ->
    @.form = {}
    @.selectedService = null
    @.selectedSuggested = true
    @.selectedTimeframe = null
    @.timeframe = [
      {timing_min_month: 12, timing_max_month: 18, desc: "At least 18-12 months before"},
      {timing_min_month: 8, timing_max_month: 12 , desc: "At least 12-8 months before"},
      {timing_min_month: 6, timing_max_month: 12, desc: "At least 12-6 months before"},
      {timing_min_month: 4, timing_max_month: 8, desc: "At least 8-4 months before"},
      {timing_min_month: 3, timing_max_month: 6, desc: "At least 6-3 months before"},
      {timing_min_month: 2, timing_max_month: 4, desc: "At least 4-2 months before"},
      {timing_min_month: 1, timing_max_month: 3, desc: "At least 3-1 months before"}]

  ctrl.submit =(form)->
    form.$valid = true if Number(@.selectedService?.id) != null && @.selectedService?.id
    if form.$valid
      if @.selectedService? && @.selectedService?.attributes.name == 'Others'
        @.form.timing_min_month = @.selectedTimeframe.timing_min_month
        @.form.timing_max_month = @.selectedTimeframe.timing_max_month
      @.save({obj: @.form})
    else
      form.itemname.$dirty = true
      form.service.$dirty = true
      form.servicename.$dirty = true
      form.timeframe.$dirty = true

  ctrl.setTimeframe = ->
    @.form.service_id = @.selectedService?.id if @.selectedService?
    unless @.selectedService?.id == null
      service = @.items.filter (obj) ->
        obj.attributes.name == ctrl.selectedService.attributes.name && obj.type == "Organisr::DefaultTodo"
      @.form.timing_min_month = service[0].attributes.timing_min_month
      @.form.timing_max_month = service[0].attributes.timing_max_month

  ctrl.suggestTags = ->
    if @.form.service_name && @.form.service_name.trim() != ''
      @.selectedSuggested = false
      @.suggest({params: @.form.service_name})

  ctrl.selectSuggeston =(name)->
    @.form.service_name = name
    @.selectedSuggested = true

  return

angular.module('client').component 'organisrAddModal',
  templateUrl: 'app/components/organisr_add_modal/index.html'
  controller: Ctrl
  bindings:
    addModal: '='
    suggestedTags: "="
    suggesting: "="
    items: "<"
    services: "<"
    timeframe: "<"
    save: "&"
    suggest: "&"
    close: "&"
