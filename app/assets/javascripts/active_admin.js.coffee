#= require active_admin/base
$(document).ready ->
  $("#images_list").sortable
    axis: "y"
    dropOnEmpty: false
    handle: ".handle"
    cursor: "crosshair"
    items: "li"
    opacity: 0.4
    scroll: true
    update: ->
      $.ajax
        type: "post"
        data: { sortable: $("#images_list").sortable("serialize"), image_id: $("#images_list").find('li')[0].id.split('_')[1] }
        dataType: "script"
        complete: (request) ->
          $("#images_list").effect "highlight"
        url: "/admin/images/sort"
