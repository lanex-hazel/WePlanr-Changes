Ctrl =(Vendor)->
  ctrl = this

  ctrl.isFave =(id)->
    @.faveList.indexOf(id) if id?

  ctrl.isFaveNonLoggedIn =(obj)->
    @.faveList.findIndex((el) -> el.id == obj.id)

  ctrl.fetchServices =(obj)->
    Vendor.allServices(obj)

  return

angular.module('client').component 'vendorList',
  templateUrl: 'app/components/vendor_list/index.html'
  controller: Ctrl
  bindings:
    title: "@"
    collection: "="
    fave: "&"
    unfave: "&"
    faveList: "<"
    processing: "="
    viewProfile: "@?"
    seeMore: "@?"
    isLoggedin: "<"
