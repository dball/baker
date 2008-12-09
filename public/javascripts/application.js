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
    var inputs = $('#ingredients').find(':text');
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

$(document).ready(function() {
  $('#ingredients').find(':text').keydown(keyDownIngredient);
});
