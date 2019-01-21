module = ($resource,Session,BASE_ENDPOINT)->

  User = $resource "#{BASE_ENDPOINT}/profile/:id", {id: "@id"},
    {
      _profile:
        method: 'GET'
        url: "#{BASE_ENDPOINT}/profile"

      favorites:
        method: 'GET'
        url: "#{BASE_ENDPOINT}/profile/favorites"

      favoritesByPage:
        method: 'GET'
        url: "#{BASE_ENDPOINT}/profile/favorites?page[number]=:number&page[size]=:size"

      update:
        method: 'PATCH'
        url: "#{BASE_ENDPOINT}/profile"

      destroy:
        method: 'DELETE'
        url: "#{BASE_ENDPOINT}/profile"

      forgotPassword:
        method: 'PATCH'
        url: "#{BASE_ENDPOINT}/users/forgot_password"

      resetPassword:
        method: 'PATCH'
        url: "#{BASE_ENDPOINT}/users/reset_password"

      verifyResetToken:
        method: 'GET'
        url: "#{BASE_ENDPOINT}/users/verify_reset_token"

      bookings:
        method: 'GET'
        url: "#{BASE_ENDPOINT}/users/bookings"
        isArray: false

      customer:
        method: 'GET'
        url: "#{BASE_ENDPOINT}/weddings/profile/:uid"
        isArray: false

      events:
        method: 'GET'
        url: "#{BASE_ENDPOINT}/profile/calendar?created_since&created_until"
        isArray: false
    }

  User.profile = (args...)->
    func = User._profile.apply(null, args)
    func.$promise.then (res) -> Session.set 'currentUser', res.data.attributes
    func

  User.wedding_date =(date)->
    date =
      day: moment(date).format('DD')
      mon: moment(date).format('MMMM')
      yr: moment(date).format('YYYY')
    return date

  return User
angular.module('client').factory('User', module)
