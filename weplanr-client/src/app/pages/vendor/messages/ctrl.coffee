Ctrl = ($scope,$stateParams,$state,$rootScope,growl,VendorMessage,MyVendor,Session,$firebaseObject,$timeout,BASE_ENDPOINT)->
  $scope.currentVendor = currentVendor = Session.get('currentVendor')
  currentUser = Session.get('currentUser')

  $scope.mobileView = 'conversations'
  $scope.tab = 'inquiry'
  $scope.unreadCount =
    booking: 0
    inquiry: 0

  $scope.switchToConversations = ->
    $scope.mobileView = 'conversations'

  messages = {}
  messageIds = []
  lastSender = null
  lastTimestamp = null
  isLastMsgQuote = no
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
  scrollToMsgsBottom = ->
    $timeout ->
      msgList = angular.element('.msg-list')[0]
      msgList.scrollTop = msgList.scrollHeight

  fetchMsgs = (uid, sameConver=false)->
    if sameConver and messageIds.length isnt 0
      VendorMessage.get(vendor_uid: currentVendor.uid, id: uid).$promise.then (res)->
        # return if messages are not for current vendor
        return if res.data.length is 0 or res.data[0].attributes.conversation_uid isnt $scope.selectedConvers.uid
        addMessage(msg) for msg in res.data
        scrollToMsgsBottom()
    else
      resetMsgs()
      VendorMessage.get(vendor_uid: currentVendor.uid, id: uid).$promise.then (res)->
        # return if messages are not for current vendor
        return if res.data.length is 0 or res.data[0].attributes.conversation_uid isnt $scope.selectedConvers.uid
        $scope.messages = groupMessages(res.data)
        scrollToMsgsBottom()

  authFinished = no
  firebase.auth().onAuthStateChanged (user)->
    return if authFinished
    authFinished = yes
    rootRef = firebase.database().ref()
    unreadMsgs = $firebaseObject(rootRef.child("/unread_messages/#{currentVendor.uid}"))
    selectedConversWatcher = null
    window.firebaseUnwatchers.push $scope.$watch 'selectedConvers', (newVal, oldVal, scope)->
      return unless newVal
      resetMsgs()
      $scope.followSelectedConvers = $firebaseObject(rootRef.child("/unread_messages/#{currentVendor.uid}/#{newVal.type}/#{newVal.uid}"))
      selectedConversWatcher() if selectedConversWatcher # unwatch previous convo
      selectedConversWatcher = $scope.followSelectedConvers.$watch -> fetchMsgs(newVal.user.wedding.uid, yes)
      window.firebaseUnwatchers.push(selectedConversWatcher)
    window.firebaseUnwatchers.push unreadMsgs.$watch ->
      $scope.unreadCount.booking = 0
      $scope.unreadCount.inquiry = 0
      angular.forEach(unreadMsgs.booking, (val, key)-> $scope.unreadCount.booking += val)
      angular.forEach(unreadMsgs.inquiry, (val, key)-> $scope.unreadCount.inquiry += val)
      # check for new inquiry
      return unless unreadMsgs.inquiry
      unreadConvoUIDs = Object.keys(unreadMsgs.inquiry)
      currentWatchedUIDs = $scope.conversations.inquiry.map((inq)-> inq.attributes.uid)
      for uid in unreadConvoUIDs
        if uid not in currentWatchedUIDs
          $scope.fetchConversations()
          return

    watchedStatus = {}
    $scope.$watch 'conversations', (newVal, oldVal, scope)->
      return unless newVal
      conversations = [].concat(newVal.booking).concat(newVal.inquiry)
      for obj in conversations
        uid = obj.attributes.user.wedding.uid
        unless watchedStatus[uid]
          watchedStatus[uid] = $firebaseObject(rootRef.child("/last_activity_time/#{uid}"))
          watcher = watchedStatus[uid].$watch((data)->
            return unless watchedStatus[data.key].$resolved
            convo = $scope.conversations.booking.find (d)-> d.attributes.user.wedding.uid is data.key
            unless convo
              convo = $scope.conversations.inquiry.find (d)-> d.attributes.user.wedding.uid is data.key
            convo.attributes.online = watchedStatus[data.key].$value isnt null
          )
          window.firebaseUnwatchers.push(watcher)

  signInFirebase = ->
    firebase.auth().signInAnonymously().catch (error)->
      console.error 'firebase auth error', error
      console.log 'retrying to authenticate firebase in 10sec...'
      $timeout((-> signInFirebase()), 10000)
  signInFirebase()

  $scope.fetchConversations = ->
    VendorMessage.query(vendor_uid: currentVendor.uid, q: $scope.searchTerm).$promise.then (res)->
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
        if uid = $stateParams.chat
          res.data.find((obj)-> uid is obj.attributes.uid).attributes
        else
          res.data[0]?.attributes
      $scope.tab = $scope.selectedConvers.type
  $scope.fetchConversations()

  $scope.getProfilePhoto = (msg)->
    photo =
      if msg.sent_by is 'user'
        $scope.selectedConvers.profile_photo
      else
        currentVendor.profile_photo
    photo

  img_endpoint = BASE_ENDPOINT.replace('api', '')
  $scope.sanitizeLink = (link)->
    if /^http/.test(link) then link else (img_endpoint + link)

  $scope.selectConvers = (obj)->
    return unless obj
    $scope.selectedConvers = obj.attributes
    $scope.mobileView = 'messages'

  $scope.send = ->
    newMsg = angular.element('#newMsg')
    return unless newMsg.val().trim()
    params =
      wedding_uid: $scope.selectedConvers.user.wedding.uid
      content: newMsg.val()
    newMsg.focus().val('')
    VendorMessage.save(vendor_uid: currentVendor.uid, data: attributes: params).$promise.then (res)->
      addMessage(res.data)
      scrollToMsgsBottom()
      $scope.selectedConvers.updated_at = res.data.attributes.created_at

  $scope.lastMsgTime = ->
    keys = Object.keys(messages)
    keys[keys.length - 1]


  $scope.showABNRequired = no
  $scope.showConnect2Stripe = no
  $scope.raiseQuote =  ->
    if currentVendor.registered_for_gst is null or not currentVendor.business_number
      $scope.showABNRequired = yes
    else if currentUser.connected_to_stripe
      wedding = $scope.selectedConvers.user.wedding
      $state.go('vendor.raise_quote',
        slug: currentVendor.slug
        weddingId: wedding.id
        weddingDate: wedding.date
        weddingName: wedding.name
      )
    else
      $scope.showConnect2Stripe = yes

  $scope.connectToStripe = ->
    wedding = $scope.selectedConvers.user.wedding
    Session.set('raiseQuoteParams',
      slug: currentVendor.slug
      weddingId: wedding.id
      weddingDate: wedding.date
      weddingName: wedding.name
    )
    window.location.href = "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_B2wMELmw7iwPtiFbqd21ZLMYajHSCO0F&scope=read_write"

  $scope.seeQuoteDetails = (quote)->
    if quote.status in ['offered', 'rejected']
      $state.go('vendor.quote', quote_id: quote.id)
    else
      $state.go('vendor.payment', quote_id: quote.id)

  $scope.clearSearch = ->
    $scope.searchTerm = ''
    $scope.fetchConversations()

angular.module('client').controller('VendorMessagesCtrl', Ctrl)
