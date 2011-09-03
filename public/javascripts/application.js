/*global $ */

var OneClickOrgs = {};

OneClickOrgs.activateLightbox = function (options) {
  var completionCallback, lightboxSelector;
  if (options && options['complete']) {
    completionCallBack = options['complete'];
  }
  if (options && options['id']) {
    lightboxSelector = '#' + options['id'];
  } else {
    lightboxSelector = '#lightbox'
  }
  $('#lightbox_screen').fadeIn();
  $(lightboxSelector).css('top', 100).animate(
    {top: 50, opacity: 'show'},
    {
      queue: false,
      complete: function () {
        $.scrollTo(lightboxSelector, 'medium');
        if (completionCallback) {
          completionCallback.call();
        }
      }
    }
  );
}
OneClickOrgs.dismissLightbox = function (options) {
  var lightboxSelector;
  if (options && options['id']) {
    lightboxSelector = '#' + options['id'];
  } else {
    lightboxSelector = '#lightbox'
  }
  $('#lightbox_screen').fadeOut();
  $(lightboxSelector).animate(
    {top: 100, opacity: 'hide'},
    {queue: false}
  );
}

OneClickOrgs.trackAnalyticsEvent = function (eventName) {
  if (_gaq) {
    _gaq.push(['_trackPageview', '/analytics_events/' + eventName]);
  }
}

$(document).ready(function () {
  // Revealed forms
  // If JavaScript is disabled, they all show by default
  $('.form-to-hide').hide();

  var cancel_button = $('<a class="cancel" href="">Cancel</a>');
  $('.form-to-hide').each(function() {
    var cloned_cancel = cancel_button.clone();
    $(this).find(':submit').after(cloned_cancel);
    
    // make it slide back up on click
    cloned_cancel.click(function(event) {
      event.preventDefault();
      $(this).closest('.form-to-hide').removeClass('active').slideUp();
    })
  })

  $('.button-form-show').show();

  $('.button-form-show').click(function() {
    var button = $(this);
    var form = $('#' + button.data('formId'));
    
    if (!form.hasClass('active')) {
      $('.form-to-hide.active').removeClass('active').slideUp();
      form.addClass('active').slideDown('medium');
    } else {
      form.removeClass('active').slideUp();
    }
  });
  
  $('.button-form').click(function() {
    window.location.href = $(this).data('url');
  });

  // Notifications
  if ($('#lightbox div.notification').length > 0) {
    OneClickOrgs.activateLightbox();
  }
  
  $('#lightbox div.notification button#close_notification').click(function ()
  {
    OneClickOrgs.dismissLightbox();
  });
});