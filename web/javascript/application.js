jQuery.ajaxSetup({  
  'beforeSend': function (xhr) {xhr.setRequestHeader("Accept", "text/javascript")}  
});

$(document).ajaxSend(function(event, request, settings) {
  if (typeof(AUTH_TOKEN) == "undefined") return;
  // settings.data is a serialized string like "foo=bar&baz=boink" (or null)
  settings.data = settings.data || "";
  settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
});

jQuery.fn.getMarathonTime = function() {
  if(!$("input#kmph").val() || ($("input#kmph").val() < 1)) {
    $(this[0]).html("");
  } else {
    var total = 42.2 * 3600 / $("input#kmph").val();
    var hours = Math.floor(total / 3600);
    total    = total - hours * 3600;
    var minutes = Math.floor(total / 60);
    var seconds = (total - minutes * 60).toFixed(0);
    $(this[0]).html(hours+' hours, '+minutes+' minutes and '+seconds+' seconds');
  }
}

jQuery.fn.getHalfMarathonTime = function() {
  if(!$("input#kmph").val() || ($("input#kmph").val() < 1)) {
    $(this[0]).html("");
  } else {
    var total = 21.1 * 3600 / $("input#kmph").val();
    var hours = Math.floor(total / 3600);
    total    = total - hours * 3600;
    var minutes = Math.floor(total / 60);
    var seconds = (total - minutes * 60).toFixed(0);
    $(this[0]).html(hours+' hours, '+minutes+' minutes and '+seconds+' seconds');
  }
}

jQuery.fn.get10KTime = function() {
  if(!$("input#kmph").val() || ($("input#kmph").val() < 1)) {
    $(this[0]).html("");
  } else {
    var total = 10 * 3600 / $("input#kmph").val();
    var hours = Math.floor(total / 3600);
    total    = total - hours * 3600;
    var minutes = Math.floor(total / 60);
    var seconds = (total - minutes * 60).toFixed(0);
    $(this[0]).html(hours+' hours, '+minutes+' minutes and '+seconds+' seconds');
  }
}

$(document).ready(function() {
  $("input#km").keyup(function() {
    $("input#mile").val(($("input#km").val() * 0.621371192).toFixed(2));
  });
  $("input#mile").keyup(function() {
    $("input#km").val(($("input#mile").val() * 1.609344).toFixed(2));
  });
  
  $("input#kmph").keyup(function() {
    $("input#mph").val(($("input#kmph").val() * 0.621371192).toFixed(2));
    $("input#minperkm").val((60 / $("input#kmph").val()).toFixed(2));
    $("input#minpermile").val((60 / $("input#kmph").val() / 0.621371192).toFixed(2));
    $("td#marathon").getMarathonTime();
    $("td#halfmarathon").getHalfMarathonTime();
    $("td#10k").get10KTime();
  });
  $("input#mph").keyup(function() {
    $("input#kmph").val(($("input#mph").val() * 1.609344).toFixed(2));
    $("input#minperkm").val((60 / $("input#mph").val() / 1.609344).toFixed(2));
    $("input#minpermile").val((60 / $("input#mph").val()).toFixed(2));
    $("td#marathon").getMarathonTime();
    $("td#halfmarathon").getHalfMarathonTime();
    $("td#10k").get10KTime();
  });
  $("input#minperkm").keyup(function() {
    $("input#kmph").val((60 / $("input#minperkm").val()).toFixed(2));
    $("input#mph").val((60 / $("input#minperkm").val() * 0.621371192).toFixed(2));
    $("input#minpermile").val(($("input#minperkm").val() * 1.609344).toFixed(2));
    $("td#marathon").getMarathonTime();
    $("td#halfmarathon").getHalfMarathonTime();
    $("td#10k").get10KTime();
  });
  $("input#minpermile").keyup(function() {
    $("input#kmph").val((60 / $("input#minpermile").val() * 1.609344).toFixed(2));
    $("input#mph").val((60 / $("input#minpermile").val()).toFixed(2));
    $("input#minperkm").val(($("input#minpermile").val() * 0.621371192).toFixed(2));
    $("td#marathon").getMarathonTime();
    $("td#halfmarathon").getHalfMarathonTime();
    $("td#10k").get10KTime();
  });
})

