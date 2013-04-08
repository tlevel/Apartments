map = 
  template       : JST["search/apartment"]
  init: ->
    do @detect_elements
    do @bind_events
  
  detect_elements: ->
    @gmap_input     = $("#gmaps-input-address")
    @gmap_error     = $("#gmaps-error")
    @search_options = 
      lat     : $("#lat").val()
      lng     : $("#lng").val()
      to      : $("#to").val()
      from    : $("#from").val()
      type_id : $("#type_id").val()
    @jmap        = $("#gmaps-canvas")
    @map_options =
      zoom: 10
      maxZoom: 18
      minZoom: 7
      center: new google.maps.LatLng(54.66102679999999, -107.2491508)
      mapTypeId: google.maps.MapTypeId.ROADMAP
    
    @geocoder      = undefined
    @map           = undefined
    @markers       = []
    
    @image  = new google.maps.MarkerImage("../img/marker-images/image.png", new google.maps.Size(18, 17), new google.maps.Point(0, 0), new google.maps.Point(9, 17))
    @shadow = new google.maps.MarkerImage("../img/marker-images/shadow.png", new google.maps.Size(30, 17), new google.maps.Point(0, 0), new google.maps.Point(9, 17))
    @shape =
      coord: [10, 0, 11, 1, 12, 2, 13, 3, 14, 4, 15, 5, 16, 6, 17, 7, 14, 8, 15, 9, 15, 10, 15, 11, 15, 12, 15, 13, 15, 14, 15, 15, 14, 16, 3, 16, 2, 15, 2, 14, 2, 13, 2, 12, 2, 11, 2, 10, 2, 9, 3, 8, 0, 7, 1, 6, 2, 5, 3, 4, 4, 3, 3, 2, 3, 1, 3, 0, 10, 0]
      type: "poly"
    
    @search_pan  = $(".my-hero-unit")
    @map_name    = "gmaps-canvas"
    $("#" + @map_name).show()
    
    @filter_btn     = $(".filter-btn")
    @modal          = $('#myModal')
    @title_modal    = $('#title-modal')
    @search_btn     = $('#fin-search')
    @gmap_input     = $("#search")
    @type_switcher  = $("#type_switcher") 
    @type           = $("#type") 
    @form_search    = $("#form-search")
    @lat_input      = $("#lat")
    @lng_input      = $("#lng")
    @search_input   = $("#search_input")
    @filter_label   = $("#filter_label")
    @from           = $("#from")
    @to             = $("#to")
    @sel_types      = $("#sel_types")
    
  bind_events: ->
    do @initialize_map
    do @search_clicker
    do @autocomplete_init
    do @form_submiter
    do @prevent_enter
    do @init_validate
    do @init_search_filter
    
  init_search_filter: ->
    @search_pan.show()
    console.log @search_input.val()
    unless @search_input.val() is ""
      @filter_label.after ' <span class="badge">' + @search_input.val() + '</span>'
    unless @to.val() is ""
      @filter_label.after ' <span class="badge">To: $' + @to.val() + '</span>'
    unless @from.val() is ""
      @filter_label.after ' <span class="badge">From: $' + @from.val() + '</span>'
    if @to.val() is "" and @from.val() is ""
      @filter_label.after ' <span class="badge">Any Price</span>'
    unless @sel_types.val() is ""
      @filter_label.after ' <span class="badge">Beds: ' + @sel_types.val() + '</span>'
    else
     @filter_label.after ' <span class="badge">Any Beds</span>' 
      
  form_submiter: ->
    me = @
    @form_search.submit =>
      if @form_search.valid()
        $(".btn-group .btn.active").each ->
          input = document.createElement("input")
          input.setAttribute "type", "hidden"
          input.setAttribute "name", "type_id[]"
          input.setAttribute "value", @value
          me.form_search.append input
          
  prevent_enter: ->
    $(window).keydown (event) ->
      if event.keyCode is 13
        event.preventDefault()
        false
        
  init_validate: ->
    @form_search.validate
      rules:
        search:
          required: true

        highlight: (label) ->
          $(label).closest(".control-group").addClass "error"

        success: (label) ->
          label.text("OK!").addClass("valid").closest(".control-group").addClass "success"
            
  search_clicker: ->
    @filter_btn.click (e) =>
      el = $(e.currentTarget)
      @modal.modal()
  
  update_ui: (address, latLng) ->
    @gmap_input.autocomplete "close"
    @gmap_input.val address
    @lat_input.val latLng.lat()
    @lng_input.val latLng.lng()
  
  autocomplete_init: ->
    me = @
    @geocoder = new google.maps.Geocoder()
    @gmap_input.autocomplete
      source: (request, response) ->
        me.geocoder.geocode
          address: request.term
        , (results, status) ->
          response $.map(results, (item) ->
            label: item.formatted_address
            value: item.formatted_address
            geocode: item
          )
      select: (event, ui) ->
        me.update_ui ui.item.value, ui.item.geocode.geometry.location
    @gmap_input.bind "keydown", (event) =>
      if event.keyCode is 13
        @geocode_lookup "address", @gmap_input.val(), true
        @gmap_input.autocomplete "disable"
      else
        @gmap_input.autocomplete "enable"
  
  geocode_lookup: (type, value, update) ->
    me = @
    update = (if typeof update isnt "undefined" then update else false)
    request = {}
    request[type] = value
    @geocoder.geocode request, (results, status) ->
      me.gmap_error.html ""
      me.gmap_error.hide()
      if status is google.maps.GeocoderStatus.OK
        if results[0]
          me.update_ui results[0].formatted_address, results[0].geometry.location
        else
          me.gmap_error.html "Sorry, something went wrong. Try again!"
          me.gmap_error.show()
      else
        if type is "address"
          me.gmap_error.html "Sorry! We couldn't find " + value + ". Try a different search term."
          me.gmap_error.show()
        else
          me.gmap_error.html "Woah... that's pretty remote! You're going to have to manually enter a place name."
          me.gmap_error.show()
          me.update_ui "", value
  
  initialize_map: ->
    @jmap.css('height', innerHeight - 158)
    unless @search_options.lat == "" and @search_options.lng == ""
      @map_options.center = new google.maps.LatLng(@search_options.lat, @search_options.lng)  
    gmap = document.getElementById(@map_name)
    @map = new google.maps.Map(gmap, @map_options)
    do @get_markers
  
  add_to_favorite: (id, element, user_id) ->
      if !$(element).hasClass 'disabled'
        $.ajax
          url: SYS.baseUrl + 'search/set_favorite'
          data: $.param({id : id, user_id : user_id})
          type: 'POST'
          dataType: 'json'
          success: (res) =>
            if res.text = "success"
              $(element).addClass("disabled").html "In Favorites"
    
  
  get_markers: ->
    me = @
    $.ajax
      url: SYS.baseUrl + 'search/get_markers'
      data: $.param({options : me.search_options})
      type: 'POST'
      dataType: 'json'
      success: (res) =>
        if res.text = "success"
          $.each res.data, (i, item) ->
            marker     = new google.maps.Marker(
              position: new google.maps.LatLng(item.lat, item.lng)
              icon    : me.image
              shadow  : me.shadow
              shape   : me.shape
            )
            infowindow = new google.maps.InfoWindow(content: "")
            google.maps.event.addListener marker, "click", ->
              $.ajax
                url: SYS.baseUrl + 'search/get_apartment'
                data: $.param({id : item.id})
                type: 'POST'
                dataType: 'json'
                success: (res) =>
                  if res.text = "success"
                    infowindow.setContent me.template({item: res.data, url : SYS.baseUrl})
                    infowindow.open me.map, marker
                    setTimeout (->
                      $("#gallery").galleryView
                        panel_width: 350
                        panel_height: 285
                        panel_scale: 'fit'
                        frame_scale: 'fit'
                    ), 70

            me.markers.push(marker);
          markerClusterer = new MarkerClusterer(me.map, me.markers,
            maxZoom: 15
            gridSize: 50
            styles: [
                      opt_textColor: "#fff"
                      height: 34
                      url: SYS.baseUrl + "img/marker-images/clusterMarker2.png" 
                      width: 34
                    ,
                      opt_textColor: "#fff"
                      height: 34
                      url: SYS.baseUrl + "img/marker-images/clusterMarker2.png"
                      width: 34
                    ,
                      opt_textColor: "#fff"
                      height: 47
                      url: SYS.baseUrl + "img/marker-images/clusterMarker3.png"
                      width: 47
                    ,
                      opt_textColor: "#fff"
                      height: 56
                      url: SYS.baseUrl + "img/marker-images/clusterMarker4.png"
                      width: 56
                    ,
                      opt_textColor: "#fff"
                      height: 56
                      url: SYS.baseUrl + "img/marker-images/clusterMarker4.png"
                      width: 56
                    ]
          )      
 
$(document).ready ->
  do map.init