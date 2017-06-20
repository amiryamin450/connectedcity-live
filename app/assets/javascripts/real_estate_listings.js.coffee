# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
@RelativeSelects = (el_parent, el_child, optionsList, childName)->
  @el_parent = el_parent.first()
  @el_child = el_child.first()
  @optionsList = optionsList
  @childName = childName
  @init()

RelativeSelects:: =
  constructor: RelativeSelects
  init: ->
    @watchSelectParent()
    @updateParentOptions()
    @setOriginValue()

  updateParentOptions: ->
    console.log @el_parent
    parentOptions = ""
    if @el_parent.attr("placeholder")
      parentOptions += "<option value=''>"+@el_parent.attr("placeholder")+"</option>"
    $.each @optionsList, (index, parent) =>
      parentOptions += "<option value='"+parent.id+"'>"+parent.name+"</option>"
    @el_parent.html(parentOptions).trigger("change").trigger("blur")

  watchSelectParent: ->
    # update child select when parent select has been changed
    _this = this
    @el_parent.on "change", ->
      parent_id = $("option:selected", this).val()
      _this.updateChildOptions parent_id

  updateChildOptions: (parent_id)->
    chosenParent = _.find @optionsList, (object)->
      object.id == parent_id

    childOptions = ""
    if !parent_id and @el_child.attr("choose_parent_first")
      childOptions += "<option value=''>"+@el_child.attr("choose_parent_first")+"</option>"
    else if @el_child.attr("placeholder")
      childOptions += "<option value=''>"+@el_child.attr("placeholder")+"</option>"

    if chosenParent and chosenParent[@childName]
      $.each chosenParent[@childName], (index, child) ->
        childOptions += "<option value='"+child.id+"'>"+child.name+"</option>"
    @el_child.html(childOptions).trigger("change").trigger("blur")

  setOriginValue: ->
    @el_parent.val(@el_parent.attr("origin_value")).trigger("change").trigger("blur")
    @el_child.val(@el_child.attr("origin_value")).trigger("change").trigger("blur")

jQuery ->
  $('#list_date_dtp').datetimepicker
    language: 'en',
    pickTime: false
  @list = [{"id":"Residential","name":"Residential","types":[{"id":"Condominiums","name":"Condominiums"},{"id":"Houses","name":"Houses"},{"id":"Townhomes","name":"Townhomes"}]},{"id":"Commercial","name":"Commercial","types":[{"id":"Industrial","name":"Industrial"},{"id":"Office","name":"Office"},{"id":"Retail","name":"Retail"}]}]
  new RelativeSelects($("#real_estate_listing_property_type"), $("#real_estate_listing_style"), @list, "types")
