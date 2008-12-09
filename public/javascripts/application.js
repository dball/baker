// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function addIngredient(input) {
  var ingredient = $(input).parents('.ingredient');
  var copy = ingredient.clone();
  copy.find('.deleter').show();
  copy.find('.adder').remove();
  ingredient.find(':text').val('');
  ingredient.before(copy);
}

function deleteIngredient(input) {
  $(input).parents('.ingredient').remove();
}
