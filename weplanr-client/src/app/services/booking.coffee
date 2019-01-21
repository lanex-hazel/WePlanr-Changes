module = ($resource,BASE_ENDPOINT)->

  $resource "#{BASE_ENDPOINT}/my_vendors/:vendor_id/bookings/:id", {id: "@id", vendor_id: '@vendor_id'},
    saveBooking:
      method: 'POST'
      url: "#{BASE_ENDPOINT}/my_vendors/:vendor_id/bookings"
    getBookings:
      method: 'GET'
      url: "#{BASE_ENDPOINT}/my_vendors/:vendor_id/bookings?view_type=:view&date=:date"
      isArray: no
    update:
      method: 'PATCH'
    blockDate:
      method: 'POST'
      url: "#{BASE_ENDPOINT}/my_vendors/:vendor_id/unavailable_dates"
    getBlockDates:
      method: 'GET'
      url: "#{BASE_ENDPOINT}/my_vendors/:vendor_id/unavailable_dates"
      isArray: no
    unblockDate:
      method: 'DELETE'
      url: "#{BASE_ENDPOINT}/my_vendors/:vendor_id/unavailable_dates/:id"

angular.module('client').factory('Booking', module)
