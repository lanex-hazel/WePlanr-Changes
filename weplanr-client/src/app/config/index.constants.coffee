# BASE_ENDPOINT = 'http://weplanr.spstage.com/api'
BASE_ENDPOINT = 'http://localhost:9000/api'
#BASE_ENDPOINT = 'http://localhost:3000'
angular.module('client')
  .constant 'BASE_ENDPOINT', BASE_ENDPOINT

@DATE_FORMAT = "MMM DD, YYYY hh:mm:ss"
@DEFAULT_PER_PAGE = 20
@DEFAULT_LOAD_ITEM = 8
@YEAR_FILTER_RANGE = 5

green_btn = '#5BC836'

@MESSAGES =
  UPDATE_SUCCESS: "Updated successfully"
  UPDATE_ERROR: "Update error"
  CREATE_SUCCESS: "Created successfully"
  DELETE_SUCCESS: "Deleted successfully"
  INTERNAL_SERVER_ERROR: "Some crazy weird stuff happened. Fix this, we will."
  BAD_REQUEST: "Error 400, bad request"
  FORM_ERROR: "Please complete all the required fields"
  INVALID_CREDS: "Invalid email or password"
  NO_DATA: "No more data to get"
  INVALID_FILE_SIZE: "File should be less than 10 mb"
  TIMEOUT: "Connection has timed out"
  LOGIN_SUCCESS: "Login success"
  LOGOUT_SUCCESS: "Logout success"
  DUPLICATE_EMAIL_ERROR: "Email address is already registered. Please log in or try a different email address."
  UPLOAD_AVATAR_SUCCESS: "Uploaded avatar successfully"
  ACCESS_DENIED: "Access Denied"

@DASHBOARD_CARD =
  PARTNER: "<span>You haven't finished personalising your Dashboard. <br> Don't forget to tell us your partner's name. <br> Personalise now?</span>"
  DATE: "<span>You haven't finished personalising your Dashboard. <br> Don't forget to tell us your wedding date. <br> Personalise now?</span>"
  LOCATION: "<span>You haven't finished personalising your Dashboard. <br> Don't forget to tell us your wedding location. <br> Personalise now?</span>"
  BUDGET: "<span>You haven't finished personalising your Dashboard. <br> Don't forget to tell us your ideal budget. <br> Personalise now?</span>"

@ACTIVATE_WARNING =
  text: 'Are you sure?'
  type: 'warning'
  showCancelButton: true
  confirmButtonColor: green_btn
  confirmButtonText: 'Yes, active this user!'
  closeOnCancel: true
  closeOnConfirm: true
  animation: true

@DEACTIVATE_WARNING =
  text: 'Are you sure?'
  type: 'warning'
  showCancelButton: true
  confirmButtonColor: '#ce4257'
  confirmButtonText: 'Yes, delete this account!'
  closeOnCancel: true
  closeOnConfirm: true
  animation: true

@DELETE_WARNING =
  text: 'Are you sure?'
  type: 'warning'
  showCancelButton: true
  confirmButtonColor: '#ce4257'
  confirmButtonText: 'Yes, delete this record!'
  closeOnCancel: true
  closeOnConfirm: true
  animation: true

@UPDATE_WARNING =
  text: 'Are you sure?'
  type: 'warning'
  showCancelButton: true
  confirmButtonColor: green_btn
  confirmButtonText: 'Yes, update record!'
  closeOnCancel: true
  closeOnConfirm: true
  animation: true

@UNFAVE_WARNING =
  text: 'Are you sure?'
  type: 'warning'
  showCancelButton: true
  confirmButtonColor: green_btn
  confirmButtonText: 'Yes, remove favourite!'
  closeOnCancel: true
  closeOnConfirm: true
  animation: true

@REMOVEBOOKING_WARNING =
  text: 'Are you sure you want to remove this booking?'
  type: 'warning'
  showCancelButton: true
  cancelButtonColor: '#383b40'
  confirmButtonColor: green_btn
  confirmButtonText: 'Yes, remove booking!'
  closeOnCancel: true
  closeOnConfirm: true
  animation: true

@FULLYBOOKED_DATE_WARNING =
  text: 'Are you sure you want to mark this day as fully booked?'
  type: 'warning'
  showCancelButton: true
  cancelButtonColor: '#383b40'
  confirmButtonColor: green_btn
  confirmButtonText: 'Yes, business is going well!'
  closeOnCancel: true
  closeOnConfirm: true
  animation: true

@UNFULLYBOOKED_DATE_WARNING =
  text: 'Are you sure you want to re open bookings on this day?'
  type: 'warning'
  showCancelButton: true
  cancelButtonColor: '#383b40'
  confirmButtonColor: green_btn
  confirmButtonText: 'Yes, I have availability!'
  closeOnCancel: true
  closeOnConfirm: true
  animation: true

@CLOSED_DATE_WARNING =
  text: 'Are you sure you want to mark yourself as closed on this day?'
  type: 'warning'
  showCancelButton: true
  cancelButtonColor: '#383b40'
  confirmButtonColor: green_btn
  confirmButtonText: 'Yes, we’re closed!'
  closeOnCancel: true
  closeOnConfirm: true
  animation: true

@UNCLOSED_DATE_WARNING =
  text: 'Are you sure you want to re open business on this day?'
  type: 'warning'
  showCancelButton: true
  cancelButtonColor: '#383b40'
  confirmButtonColor: green_btn
  confirmButtonText: 'Yes, we’re open!'
  closeOnCancel: true
  closeOnConfirm: true
  animation: true

@SETCOVER_PHOTO_WARNING =
  text: 'Are you sure you want to change your cover photo?'
  type: 'warning'
  showCancelButton: true
  cancelButtonColor: '#383b40'
  confirmButtonColor: green_btn
  confirmButtonText: 'Yes, change my cover photo!'
  closeOnCancel: true
  closeOnConfirm: true
  animation: true

@REMOVE_TODO_WARNING =
  text: 'Are you sure you want to remove this todo item?'
  type: 'warning'
  showCancelButton: true
  cancelButtonColor: '#383b40'
  confirmButtonColor: green_btn
  confirmButtonText: 'Yes, remove this todo item!'
  closeOnCancel: true
  closeOnConfirm: true
  animation: true

@UNREMOVE_TODO_WARNING =
  text: 'Are you sure you want to return this todo item?'
  type: 'warning'
  showCancelButton: true
  cancelButtonColor: '#383b40'
  confirmButtonColor: green_btn
  confirmButtonText: 'Yes, return this todo item!'
  closeOnCancel: true
  closeOnConfirm: true
  animation: true

@FAVOURITE_MSG =
  title: 'Swoon worthy!'
  text: 'We\'ve added this vendor on your favourites list.'
  type: 'success'
  confirmButtonColor: green_btn

@UNFAVOURITE_MSG =
  text: 'We\'ve removed this vendor on your favourites list.'
  type: 'success'
  confirmButtonColor: green_btn

@UPLOAD_SUCCESS =
  text: 'Successfully uploaded!'
  type: 'success'
  confirmButtonColor: green_btn

@CHANGE_TODO_LINK =
  text: 'Do you want to move your booking to this to do item?'
  type: 'warning'
  showCancelButton: true
  cancelButtonColor: '#383b40'
  confirmButtonColor: green_btn
  confirmButtonText: 'Associate item to this booking'
  closeOnCancel: true
  closeOnConfirm: true
  animation: true

@RECALCULATE_BUDGET_PLANNED =
  title: ''
  text: 'Are you sure you want to recalculate your planned items?'
  type: 'warning'
  showCancelButton: true
  cancelButtonColor: '#383b40'
  confirmButtonColor: green_btn

@MONTHS = [
  {key: "1", value: "January"},
  {key: "2", value: "Feburary"},
  {key: "3", value: "March"},
  {key: "4", value: "April"},
  {key: "5", value: "May"},
  {key: "6", value: "June"},
  {key: "7", value: "July"},
  {key: "8", value: "August"},
  {key: "9", value: "September"},
  {key: "10", value: "October"},
  {key: "11", value: "November"},
  {key: "12", value: "December"}
]


@PIE_OPTIONS =(color)->
  animate:
    duration: 800
    enabled: true
  barColor: color
  scaleColor: false
  lineWidth: 6
  lineCap: 'circle'
  size: 200

@LEAVE =
  ALL: "All"
  PENDING: "Pending"
  APPROVED: "Approved"
  REJECTED: "Rejected"
  CANCELLED: "Cancelled"

@DEFAULT_PHOTO = '/vendor/images/default-placeholder.png'

@GST =
  INCLUSIVE: '* Prices inclusive of GST'
  EXCLUSIVE: '* This vendor does not charge GST'
