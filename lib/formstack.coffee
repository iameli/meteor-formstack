#
# Meteor Formstack API
# Written for Victory Briefs by Eli Mallon
# The backbone of client data entry.
#
theRoot = exports ? this # This probably doesn't matter for Meteor but it feels like good form.
do (root=theRoot) ->
  # Generate Formstack JSON URLs
  FS_URL = 'https://www.formstack.com/api/v2/'
  url = (param) -> FS_URL + param + '.json'
  
  # Currently there is a Formstack API bug -- sometimes success is returned as a string, sometimes an
  # int. This function hacks around this, makes sure it's always cast to an int.
  fixParams = (data) ->
    if data.success?
      if typeof data.success == 'string'
        data.success = parseInt(data.success)
    return data
  root.Formstack = class Formstack
    #
    # Create a new Formstack object.
    # params.token = token.
    #
    constructor: (params) ->
      @token = params.token
      @authHeader = {"Authorization": "Bearer " + @token}
    #
    # Return a list of all forms.
    #
    getForms: () ->
      resp = Meteor.http.call "GET", url('form'), headers: @authHeader
      return fixParams(resp.data)
    #
    # Get a singlular form.
    #
    getForm: (id) ->
      resp = Meteor.http.call "GET", url('form/'+id), headers: @authHeader
      return fixParams(resp.data)
    #
    # Create form
    # Only requried param is name. 
    #
    createForm: (params) ->
      resp = Meteor.http.call "POST", url('form'), {headers: @authHeader, data: params}
      return fixParams(resp.data)
    #
    # Modify form
    # Params are the same here
    #
    modifyForm: (id, params) ->
      resp = Meteor.http.call "PUT", url('form/'+id), {headers: @authHeader, data: params}
      return fixParams(resp.data)
    #
    # Delete form
    # params.id = id of form to delete
    #
    deleteForm: (id) ->
      resp = Meteor.http.call "DELETE", url('form/'+id), headers: @authHeader
      return fixParams(resp.data)
    #
    # Duplicate form
    # id
    # Returns an object with the id of the new form
    #
    copyForm: (id) -> 
      resp = Meteor.http.call "POST", url('form/'+id+'/copy'), headers: @authHeader
      return fixParams(resp.data)
    