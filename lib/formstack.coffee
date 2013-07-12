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
      if typeof data.success == 'number'
        data.success = "" + data.success
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
    # FORMS
    #
    
    #
    # Return a list of all forms.
    #
    getForms: () ->
      resp = Meteor.http.call "GET", url('form'), headers: @authHeader
      return fixParams(resp.data)
    #
    # Get a singlular form.
    #
    getForm: (form_id) ->
      resp = Meteor.http.call "GET", url("form/#{form_id}"), headers: @authHeader
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
    modifyForm: (form_id, params) ->
      resp = Meteor.http.call "PUT", url("form/#{form_id}"), {headers: @authHeader, data: params}
      return fixParams(resp.data)
    #
    # Delete form
    # params.id = id of form to delete
    #
    deleteForm: (form_id) ->
      resp = Meteor.http.call "DELETE", url("form/#{form_id}"), headers: @authHeader
      return fixParams(resp.data)
    #
    # Duplicate form
    # id
    # Returns an object with the id of the new form
    #
    copyForm: (form_id) -> 
      resp = Meteor.http.call "POST", url("form/#{form_id}/copy"), headers: @authHeader
      return fixParams(resp.data)
      
    #
    # FIELDS
    #
    
    #
    # Get all fields for a specified form.
    #
    getFields: (form_id) ->
      resp = Meteor.http.call "GET", url("form/#{form_id}/field"), headers: @authHeader
      return fixParams(resp.data)
    #
    # Create a new field for the specified form
    #
    createField: (form_id, params) ->
      resp = Meteor.http.call "POST", url("form/#{form_id}/field"), {data: params, headers: @authHeader}
      return fixParams(resp.data)
    #
    # Get the details of a specific field
    #
    getField: (field_id) ->
      resp = Meteor.http.call "GET", url("field/#{field_id}"), headers: @authHeader
      return fixParams(resp.data)
    #
    # Update the specified field
    #
    modifyField: (field_id, params) ->
      resp = Meteor.http.call "PUT", url("field/#{field_id}"), {data: params, headers: @authHeader}
      return fixParams(resp.data)
    #
    # Delete the specified field
    #
    deleteField: (field_id) ->
      resp = Meteor.http.call "DELETE", url("field/#{field_id}"), headers: @authHeader
      return fixParams(resp.data)
      
    #
    # SUBMISSIONS
    #
    
    #
    # Get all submissions for a specific form.
    #
    getSubmissions: (form_id) ->
      resp = Meteor.http.call "GET", url("form/#{form_id}/submission"), headers: @authHeader
      return fixParams(resp.data)
      
    #
    # Create a new submission for the specified form
    #
    createSubmission: (form_id, params) ->
      my_url = url "form/#{form_id}/submission"
      resp = Meteor.http.call "POST", url("form/#{form_id}/submission"),
        headers: @authHeader
        data: params
      return fixParams(resp.data)
    
    #
    # Get the details of a specific submission
    #
    getSubmission: (submission_id) ->
      resp = Meteor.http.call "GET", url("submission/#{submission_id}"), headers: @authHeader
      return fixParams(resp.data)
      
    #
    # Update the specified submission
    #
    modifySubmission: (submission_id, params) ->
      resp = Meteor.http.call "PUT", url("submission/#{submission_id}"),
        headers: @authHeader
        data: params
      return fixParams(resp.data)
      
    #
    # Delete the specified submission
    #
    deleteSubmission: (submission_id, params) ->
      resp = Meteor.http.call "DELETE", url("submission/#{submission_id}"), headers: @authHeader
      return fixParams(resp.data)
      
      
      
      