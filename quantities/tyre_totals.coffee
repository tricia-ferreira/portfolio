sane_tyre_qty_check = (object) ->
  url = object.closest('.js-tyre-quantity-block').data('path')
  object_type = object.data('type')
  type = if object_type == 'scrap' || object_type == 'shred' then "#{object_type}_weight" else "#{object_type}_qty"
  $.ajax
    url: url
    type: 'GET'
    dataType: 'json'
    data: { "tyre_qty": { "#{type}":object.val() } }
    complete: (data) ->
      if data["responseText"] == 'true'
        object.closest('.tyre__quantities').removeClass('tyre__quantities--warning')
      else
        object.closest('.tyre__quantities').addClass('tyre__quantities--warning')

window.set_total_tyre_qty = ->
  tyre_qty = 0
  $('.js-tyre_qty').each ->
    if $(this).val() > 0
      tyre_qty += parseInt($(this).val())
  $('.js-total-tyre-qty').html(tyre_qty)

window.set_total_tyre_weight = ->
  tyre_weight = 0
  $('.js-tyre_qty').each ->
    if $(this).val() > 0
      weight_amount = calculate_average_weight($(this))
      tyre_weight += weight_amount
  $('.js-tyre_weight').each ->
    if $(this).val() > 0
      tyre_weight += parseFloat($(this).val())
  $('.js-total-tyre-weight').html(weight_format(tyre_weight))
  $('.tyre').data('total-tyre-weight', tyre_weight)
  set_load_capacity_warning()

window.init_vehicle_select = (object) ->
  selected_option = object.find(":selected")
  if selected_option.val() != ""
    set_vehicle_size(selected_option)
    set_load_capacity(selected_option)
  else
    $('.js-vehicle-type').closest('tr').addClass("hidden")
    $('.js-load-capacity').closest('tr').addClass("hidden")

window.init_sane_tyre_qty = ->
  $('.js-tyre_qty, .js-tyre_weight').each ->
    if $(this).val() > 0
      sane_tyre_qty_check($(this))

calculate_average_weight = (object) ->
  average = parseFloat(object.data('average-weight'))
  parseFloat(object.val()) * average

set_vehicle_size = (object) ->
  size = object.data('vehicle-size')
  if size
    $('.js-vehicle-type').closest('tr').removeClass("hidden")
    $('.js-vehicle-type').html(size)

set_load_capacity = (object) ->
  tare_weight = object.data('tare-weight')
  gross_weight = object.data('gross-weight')
  if tare_weight && gross_weight
    capacity = gross_weight - tare_weight
    $('.js-load-capacity').closest('tr').removeClass("hidden")
    $('.js-load-capacity').data("capacity", capacity)
    $('.js-load-capacity').html(weight_format(capacity))
    set_load_capacity_warning()
  else
    $('.js-load-capacity').closest('tr').addClass("hidden")
    $('.js-load-capacity').removeData("capacity")

set_load_capacity_warning = ->
  weight = $('.js-tyre-quantity-block').data('total-tyre-weight')
  load_weight = $('.js-load-capacity').data('capacity')
  if weight > load_weight
    $('.js-tyre-totals').addClass('tyre__quantities--warning')
  else
    $('.js-tyre-totals').removeClass('tyre__quantities--warning')

$(document).on "focusout", ".js-tyre_qty, .js-tyre_weight", (e) ->
  window.set_total_tyre_qty()
  window.set_total_tyre_weight()
  if $(this).val() > 0
    sane_tyre_qty_check($(this))
  else
    $(this).closest('.tyre__quantities').removeClass('tyre__quantities--warning')

$(document).on "focusout", ".js-tyre-quantity-block .js-non_zero_input", ->
  if $(this).val() == ""
    $(this).removeClass("js-non_zero_input")
    $(this).addClass("hide_zero")
    $(this).val(0)

$(document).on "change", ".js-vehicle-select", (e) ->
  window.init_vehicle_select($(this))
  set_load_capacity_warning()
