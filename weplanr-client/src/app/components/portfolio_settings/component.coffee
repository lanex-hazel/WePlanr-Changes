Ctrl = (growl,Upload)->
  ctrl = this

  ctrl.$onInit= ->
    @.files = []
    @.uploadFiles = []
    @.isUploadError = false

  ctrl.reset =(files)->
    files.splice(0,files.length)
    @.isUploadError = false

  ctrl.remove =(index,file)->
    file.splice(index,1)
    @.check_files(file)

  ctrl.onUpload =(files,redirect=false)->
    @.upload({files:files,redirect:redirect})

  ctrl.check_files =(files)->
    uploadErrors = ''
    uploadLen = files.length
    if uploadLen > 12 - @.photos.length || @.photos.length == 12
      files.splice(0,uploadLen)
      @.files = []
      swal('Reached photo limit!','You are only allowed to upload up to 12 photos.','error')
    else if uploadLen > 0
      i = 0
      while i < uploadLen
        if files[i].$error
          uploadErrors += identifyError(files[i])
        else
          @.uploadFiles.push files[i]
        i++
      files.splice(i,uploadLen)
      @.files = []
      swal('Following files are not valid',uploadErrors,'warning') if uploadErrors

  identifyError =(file)->
    switch file.$error
      when 'pattern'
        return file.name + " is an invalid image file.\n"
      when 'minWidth', 'minHeight'
        return file.name + " must be atleast 800x600.\n"
      when 'maxSize'
        return file.name + " is larger than the maximum allowed limit of 5MB.\n"


  return
angular.module('client').component 'portfolioSettings',
  templateUrl: 'app/components/portfolio_settings/index.html'
  controller: Ctrl
  bindings:
    loading: "="
    uploading: "="
    photos: "="
    destroy: "&"
    upload: "&"
    setCover: "&"
