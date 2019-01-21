Ctrl = ($rootScope,$scope,$state,Cookie,Message,Session,VendorQuote,Service,$firebaseObject,$timeout,BASE_ENDPOINT)->
  $scope.unreadCount =
    booking: 0
    inquiry: 0
  $scope.currentUser = currentUser = Session.get('currentUser')
  $scope.mobileView = 'conversations'
  $scope.tab = 'inquiry'

  $scope.categories = Cookie.get('categories')
  unless $scope.categories?
    Service.categories().$promise.then (res)->
      Cookie.set('categories', res.data)
      $scope.categories = res.data

  $scope.switchToConversations = ->
    $scope.mobileView = 'conversations'

  messages = {}
  messageIds = []
  lastSender = null
  lastTimestamp = null
  isLastMsgQuote = no
  $scope.vendorCategory = 'Other'
  resetMsgs = ->
    $scope.messages = {}
    messages = {}
    messageIds = []
    lastSender = null
    lastTimestamp = null
    isLastMsgQuote = no
  groupMessages = (array)->
    addMessage(obj) for obj in array
    messages
  addMessage = (obj)->
    msgId = parseInt(obj.id)
    return if msgId in messageIds
    if lastSender isnt obj.attributes.sent_by or
       moment(lastTimestamp).diff(obj.attributes.created_at, 'day') isnt 0 or
       messageIds.length is 0 or
       obj.attributes.quote or isLastMsgQuote
      lastSender = obj.attributes.sent_by
      lastTimestamp = obj.attributes.created_at
      messages[lastTimestamp] = [obj.attributes]
    else
      messages[lastTimestamp].push(obj.attributes)
    isLastMsgQuote = obj.attributes.quote isnt null
    messageIds.push(msgId)
    messages
  scrollToMsgsBottom = ->
    $timeout ->
      msgList = angular.element('.msg-list')[0]
      msgList.scrollTop = msgList.scrollHeight

  fetchMsgs = (uid, sameConver=false)->
    if sameConver and messageIds.length isnt 0
      Message.get(id: uid).$promise.then (res)->
        # return if messages are not for current vendor
        return if res.data.length is 0 or res.data[0].attributes.conversation_uid isnt $scope.selectedConvers.uid
        addMessage(msg) for msg in res.data
        scrollToMsgsBottom()
    else
      resetMsgs()
      Message.get(id: uid).$promise.then (res)->
        # return if messages are not for current vendor
        return if res.data.length is 0 or res.data[0].attributes.conversation_uid isnt $scope.selectedConvers.uid
        $scope.messages = groupMessages(res.data)
        scrollToMsgsBottom()

  authFinished = no
  firebase.auth().onAuthStateChanged (user)->
    return if authFinished
    authFinished = yes
    rootRef = firebase.database().ref()
    unreadMsgs = $firebaseObject(rootRef.child("/unread_messages/#{currentUser.wedding_details.uid}"))
    selectedConversWatcher = null
    window.firebaseUnwatchers.push $scope.$watch 'selectedConvers', (newVal, oldVal, scope)->
      return unless newVal
      resetMsgs()
      $scope.followSelectedConvers = $firebaseObject(rootRef.child("/unread_messages/#{currentUser.wedding_details.uid}/#{newVal.type}/#{newVal.uid}"))
      selectedConversWatcher() if selectedConversWatcher # unwatch previous convo
      selectedConversWatcher = $scope.followSelectedConvers.$watch ->
        fetchMsgs(newVal.vendor_uid, yes)
      window.firebaseUnwatchers.push selectedConversWatcher
    window.firebaseUnwatchers.push unreadMsgs.$watch ->
      $scope.unreadCount.booking = 0
      $scope.unreadCount.inquiry = 0
      angular.forEach(unreadMsgs.booking, (val, key)-> $scope.unreadCount.booking += val)
      angular.forEach(unreadMsgs.inquiry, (val, key)-> $scope.unreadCount.inquiry += val)

    watchedStatus = {}
    $scope.$watch 'conversations', (newVal, oldVal, scope)->
      return unless newVal
      conversations = [].concat(newVal.booking).concat(newVal.inquiry)
      for obj in conversations
        uid = obj.attributes.vendor_uid
        unless watchedStatus[uid]
          window.asd = watchedStatus[uid] = $firebaseObject(rootRef.child("/last_activity_time/#{uid}"))
          watcher = watchedStatus[uid].$watch((data)->
            lastActivTime = watchedStatus[data.key].$value
            convo = $scope.conversations.inquiry.find (d)-> d.attributes.vendor_uid is data.key
            convo ?= $scope.conversations.booking.find (d)-> d.attributes.vendor_uid is data.key
            convo.attributes.online =
              if lastActivTime
                lastActivMinute = Math.floor((new Date()).getTime() - (new Date(lastActivTime)).getTime()) / 60000
                lastActivMinute < 10.001
              else
                no

          )
          window.firebaseUnwatchers.push(watcher)

  signInFirebase = ->
    firebase.auth().signInAnonymously().catch (error)->
      console.error 'firebase auth error', error
      console.log 'retrying to authenticate firebase in 10sec...'
      $timeout((-> signInFirebase()), 10000)
  signInFirebase()

  $scope.fetchConversations = ->
    Message.query(q: $scope.searchTerm).$promise.then (res)->
      inquiries = []
      bookings = []
      for obj in res.data
        if obj.attributes.type is 'booking'
          bookings.push obj
        else
          inquiries.push obj
      $scope.conversations =
        booking: bookings
        inquiry: inquiries
      $scope.selectedConvers =
        if composeForVendor = Session.get('composeForVendor')
          Session.remove('composeForVendor')
          if previousConvers = res.data.find((obj)-> composeForVendor.uid is obj.attributes.vendor_uid)
            previousConvers.attributes
          else
            if $scope.categories?
              $scope.vendorCategory = $scope.categories.filter (obj,idx, arr)->
                obj.id == Number(composeForVendor.primary_service_id)
            newConvers =
              attributes:
                vendor_uid: composeForVendor.uid
                profile_photo: composeForVendor.profile_photo
                public_contact_name: composeForVendor.public_contact_name
                business_name: composeForVendor.business_name
                vendor_service: $scope.vendorCategory[0] and $scope.vendorCategory[0].name
                vendor_slug: composeForVendor.slug
                type: 'inquiry'
            $scope.conversations.inquiry.push(newConvers)
            newConvers.attributes
        else if uid = $state.params.chat
          res.data.find((obj)-> uid is obj.attributes.uid).attributes
        else
          res.data[0]?.attributes
      $scope.tab = $scope.selectedConvers.type
  $scope.fetchConversations()

  $scope.$watch 'selectedConvers', (newVal, oldVal, scope)->
    return unless newVal
    # fetchMsgs(newVal.vendor_uid)

  $scope.getProfilePhoto = (msg)->
    photo =
      if msg.sent_by is 'user'
        currentUser.profile_photo
      else
        $scope.selectedConvers.profile_photo
    photo

  img_endpoint = BASE_ENDPOINT.replace('api', '')
  $scope.sanitizeLink = (link)->
    if /^http/.test(link) then link else (img_endpoint + link)

  $scope.selectConvers = (obj)->
    return unless obj
    $scope.selectedConvers = obj.attributes
    $scope.mobileView = 'messages'

  $scope.send = ->
    newMsg = angular.element('#new-msg-input')
    return unless newMsg.val().trim()
    params =
      vendor_uid: $scope.selectedConvers.vendor_uid
      content: newMsg.val()
    newMsg.focus().val('')
    Message.save(data: attributes: params).$promise.then (res)->
      $scope.messages = addMessage(res.data)
      scrollToMsgsBottom()
      $scope.selectedConvers.updated_at = res.data.attributes.created_at
      # for 1st-time message to vendor
      # update firebase of watched uid
      unless $scope.selectedConvers.uid
        tempConvo = angular.copy($scope.selectedConvers)
        tempConvo.uid = res.data.attributes.conversation_uid
        $scope.selectedConvers = tempConvo

  $scope.lastMsgTime = ->
    keys = Object.keys(messages)
    keys[keys.length - 1]

  $scope.rejectAction = (quote) ->
    $scope.quoteLoading = on
    VendorQuote.reject(vendor_id: $scope.selectedConvers.vendor_slug, id: quote.id).$promise
      .then (res)-> quote.status = res.data.attributes.status
      .finally -> $scope.quoteLoading = no

  $scope.clearSearch = ->
    $scope.searchTerm = ''
    $scope.fetchConversations()

angular.module('client').controller('MessagesCtrl', Ctrl)
