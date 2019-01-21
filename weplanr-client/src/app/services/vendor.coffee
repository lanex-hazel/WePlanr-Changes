module = ($resource,BASE_ENDPOINT)->

  Vendor = $resource "#{BASE_ENDPOINT}/vendors/:vendor_uid", {id: "@id"},
    {
      getlist:
        method: 'GET'
        url: "#{BASE_ENDPOINT}/vendors?page[number]=:number&page[size]=:size"
        isArray: false
      featured:
        url: "#{BASE_ENDPOINT}/vendors/featured?page[number]=:number&page[size]=:size"
        isArray: false
      get:
        method: 'GET'
      favourite:
        method: 'POST'
        url: "#{BASE_ENDPOINT}/vendors/:id/favorite"
      unfavourite:
        method: 'DELETE'
        url: "#{BASE_ENDPOINT}/vendors/:id/unfavorite"
      query:
        method: 'GET'
        url: "#{BASE_ENDPOINT}/vendors"
        isArray: false
      categorize:
        method: 'GET'
        url: "#{BASE_ENDPOINT}/vendors"
        isArray: false
      getEvents:
        method: 'GET'
        url: "#{BASE_ENDPOINT}/vendors/:id/events"
        isArray: false
      setCoverPhoto:
        method: 'PATCH'
        url: "#{BASE_ENDPOINT}/vendors/:id/cover_photo"
      verifyInviteToken:
        url: "#{BASE_ENDPOINT}/verify_invite_token/:token"
        params: token: '@token'
      registerViaInvite:
        method: 'POST'
        url: "#{BASE_ENDPOINT}/register/vendor/:token"
        params: token: '@token'
    }
    
  angular.extend Vendor,
    formatVendor: (obj)->
      {
        id: parseInt(obj.id),
        attributes: {
          business_name: obj.attributes.business_name,
          address_summary: obj.attributes.address_summary,
          sample_photo: if obj.attributes.photo_urls.length > 1 then obj.attributes.photo_urls[0].url else null,
          profile_photo: obj.attributes.profile_photo,
          slug: obj.attributes.slug,
          services: obj.attributes.services
        }
      }

    allServices: (obj) ->
      _.union(obj.primary_services, obj.secondary_services)

  Vendor

angular.module('client').factory('Vendor', module)
