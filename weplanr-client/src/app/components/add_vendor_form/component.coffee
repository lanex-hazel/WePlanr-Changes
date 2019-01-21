Ctrl = ->
  ctrl = this

  ctrl.$onInit = ->
    @.formInvalid = false
    @.patternInvalid =
      url: false
      number: false
      email: false
    @.vendor = {}
    switch(@.mode)
      when 'edit'
        @.title = "Edit details of the business booked outside WePlanr below"
        @.vendor = angular.copy @.obj.attributes.outside_vendor
        @.vendor.total_fee = angular.copy @.obj.attributes.actual
        @.vendor.paid = angular.copy @.obj.attributes.paid
        contact = @.vendor.primary_phone.toLowerCase()
        @.vendor.primary_phone = null if contact == 'undefined' or contact == 'nan'
      when 'booked'
        @.title = "Congratulations on your booking!"
        @.vendor = angular.copy @.obj.attributes.vendor
        @.vendor.total_fee = angular.copy @.obj.attributes.actual
        @.vendor.paid = angular.copy @.obj.attributes.paid
      else
        @.title = "Add details of the business booked outside WePlanr below"

  ctrl.submit =(form)->
    if form.$valid
      if @.mode == 'edit'
        @.vendor.total_fee = @.parseNum(@.vendor.total_fee)
        @.vendor.paid = @.parseNum(@.vendor.paid)
        @.update({obj: @.obj, params: @.vendor})
      else
        @.vendor.total_fee = @.parseNum(@.vendor.total_fee)
        @.vendor.paid = @.parseNum(@.vendor.paid)
        @.save({obj:@.obj, params: @.vendor})
    else
      @.formInvalid = true
      # @.patternInvalid.number = true if form.contact_number.$error.pattern
      @.patternInvalid.email = true if form.email.$error.pattern
      @.patternInvalid.url = true if form.url.$error.pattern
      console.error 'invalid form'

  ctrl.parseNum = (val)->
    strNum = String(val).replace(/[\D\s]+/g, '')
    Number(strNum)

  return

angular.module('client').component 'addVendorForm',
  templateUrl: 'app/components/add_vendor_form/index.html'
  controller: Ctrl
  bindings:
    toggleForm: "&"
    obj: "="
    mode: "<"
    removeModal: "="
    save: "&"
    update: "&"