// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function addIngredient(input) {
  var ingredient = $(input).parents('.ingredient');
  var copy = ingredient.clone();
  copy.find('.deleter').show();
  copy.find('.adder').remove();
  ingredient.find(':text').val('');
  ingredient.before(copy);
  $(input).parents('tr').find(':text')[0].focus();
}

function deleteIngredient(input) {
  $(input).parents('.ingredient').remove();
}

function keyDownIngredient(event) {
  if (event.keyCode == 13) {
    var inputs = $('.edits_many').find(':text');
    for (var i=0; i<inputs.length; i++) {
      if (inputs[i] == this) {
        if (i + 1 == inputs.length) {
          addIngredient(this);
        } else {
          nextInput = inputs[i + 1];
          nextInput.focus();
          nextInput.select();
        }
      }
    }
    return false;
  }
}

jQuery.fn.alignAround = function(expr, ch) {
  var values = new Array();
  var elements = this.find(expr);
  for (var i=0; i<elements.length; i++) {
    var el = $(elements[i]);
    var text = el.text();
    var splits = text.split(ch);
    if (splits.length == 2) {
      values[values.length] = splits;
    } else {
      splits = new Array();
      splits[0] = text;
      splits[1] = '';
      values[values.length] = splits;
    }
  }
  var max_lengths = [0, 0];
  for (var i=0; i<values.length; i++) {
    var value = values[i];
    for (var j=0; j < 2; j++) {
      if (value[j].length > max_lengths[j]) {
        max_lengths[j] = value[j].length;
      }
    }
  }
  for (var i=0; i<values.length; i++) {
    var value = values[i];
    var s = '';
    for (var j=0; j<max_lengths[0] - value[0].length; j++) {
      s += '\u00A0';
    }
    s += value[0];
    if (value[1] == '') {
      for (j=0; j<=max_lengths[1] - value[1].length; j++) {
        s += '\u00A0';
      }
    } else {
      s += ch;
      s += value[1];
      for (var j=0; j<max_lengths[1] - value[1].length; j++) {
        s += '\u00A0';
      }
    }
    $(elements[i]).text(s);
  }
}

$(document).ready(function() {
  $('#header').corner('bottom 20px');
  $('#header h1').corner('bottom 15px');
  $('#content').corner('20px');
  $('#content #main').corner('15px');
  $('.edits_many').find(':text').keydown(keyDownIngredient);
  $('#ingredients').alignAround('.percent', '.');
  $('#ingredients').alignAround('.weight', '.');
  $('.autosubmit :input').change(function() {
    this.form.submit();
  });
  $('#header h1 a').hover(
    function() {
      $(this).addClass('highlight');
      var index = $('#header h1 a').index(this);
      if (index > 0) {
        $('#header h1 a:lt(' + index + ')').addClass('highlight');
      }
    },
    function() {
      $(this).removeClass('highlight');
      var index = $('#header h1 a').index(this);
      if (index > 0) {
        $('#header h1 a:lt(' + index + ')').removeClass('highlight');
      }
    }
  );
});
