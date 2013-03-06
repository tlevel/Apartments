// Generated by CoffeeScript 1.4.0
var user;

user = {
  init: function() {
    this.detectElements();
    return this.bindEvents();
  },
  detectElements: function() {
    return this.form = $('.form-actions');
  },
  bindEvents: function() {
    var picker;
    this.initUploader();
    this.initValidation();
    picker = $('.date').datepicker();
    return picker.on('changeDate', function(ev) {
      return picker.datepicker("hide");
    });
  },
  initValidation: function() {
    return this.form.validate({
      rules: {
        first_name: {
          minlength: 2,
          required: true
        },
        last_name: {
          minlength: 2,
          required: true
        },
        email: {
          required: true,
          email: true
        }
      },
      highlight: function(label) {
        return $(label).closest(".control-group").addClass("error");
      }
    });
  },
  initUploader: function() {
    var _this = this;
    return new uploader({
      selector: $('input[type=file]'),
      addCallback: function(e, data) {
        return $('#avatar-img').attr('src', SYS.spinerUrl);
      },
      doneCallback: function(e, data) {
        $('#avatar-img').attr('src', SYS.baseUrl + data.result.data);
        return $('#avatar').val(data.result.data);
      },
      progressCallback: function(progress) {
        return $(".upload-progress").text("uploading... " + progress + "%");
      }
    });
  }
};

$(document).ready(function() {
  return user.init();
});