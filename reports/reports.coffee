# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.init_reports_table = ->
  title = $('#reports-table').data('report-name')
  window.reports_table = $('#reports-table').dataTable
    paginationType: "bootstrap"
    bPaginate: false
    bLengthChange: false
    bSort: false
    dom: 'Btip'
    buttons: [
      {
        extend: 'csvHtml5',
        title: title
      },
    ]

window.set_report_type = ->
  if window.location.href.match('reports')
    report_type = window.location.href.split('=')[1]
    $('.js-toggle-report-type').val(report_type).change()

show_report_type = (object) ->
  selected = object.val()
  form = object.closest('form')
  form.find(".js-date-select-wrapper").removeClass('hidden')
  if selected == 'entities_report' || selected == 'transporter_agreements_report'
    form.find(".js-date-select-wrapper").addClass('hidden')

$(document).on 'change', '.js-toggle-report-type', (e) ->
  e.preventDefault()
  show_report_type($(this))

$(document).on 'draw.dt', '.dataTable', ->
  $('.js-report-loader').addClass('hidden')
