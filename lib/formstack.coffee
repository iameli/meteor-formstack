theRoot = exports ? this
do (root=theRoot) ->
  FS_URL = 'https://www.formstack.com/api/v2/'
  url = (param) -> FS_URL + param + '.json'
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
      return resp.data.forms
    #
    # Get a singlular form.
    #
    getForm: (id) ->
      resp = Meteor.http.call "GET", url('form/'+id), headers: @authHeader
      return resp
    #
    # Create form
    # Only requried param is name. 
    #
    createForm: (params) ->
      resp = Meteor.http.call "POST", url('form'), {headers: @authHeader, data: params}
      return resp
    #
    # Modify form
    # Params are the same here
    #
    modifyForm: (id, params) ->
      Meteor.http.call "PUT", url('form/'+id), {headers: @authHeader, data: params}
    #
    # Delete form
    # params.id = id of form to delete
    #
    deleteForm: (id) ->
      Meteor.http.call "DELETE", url('form/'+id), headers: @authHeader