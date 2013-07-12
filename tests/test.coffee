do ->
  #Create formstack object.
  fstack = new Formstack {token: process.env.FORMSTACK_TEST_TOKEN}
  
  #Setup form test.
  test_form_id = null
  test_form_copy_id = null
  test_form_name = "METEOR_FORMSTACK_TEST"
  test_form_button_title = "Test Submit Button"
  
  #Test every-form retrieval.
  Tinytest.add 'Formstack - GET /form', (test) ->
    try
      resp = fstack.getForms()
    catch e
      test.isFalse e, "Error upon initial connection. If the code is 401, you possibly forgot to set the FORMSTACK_TEST_TOKEN environment variable. " + e
  
  #Test form creation.
  Tinytest.add 'Formstack - POST /form', (test) ->
    resp = fstack.createForm 
      name: test_form_name
    test.isTrue resp.id?, "Should get a new form ID when we POST /form."
    test_form_id = resp.id
    
  #Test form modification.
  Tinytest.add 'Formstack - PUT /form/:id', (test) ->
    resp = fstack.modifyForm test_form_id, {submit_button_title: test_form_button_title}
    test.equal resp.success, "1", "Should modify successfully."
    
  #Test form retrieval.
  Tinytest.add 'Formstack - GET /form/:id', (test) ->
    resp = fstack.getForm test_form_id
    test.equal resp.submit_button_title, test_form_button_title, "Button title should have been modified earlier."
    test.equal resp.name, test_form_name, "Should be able to retrieve the name of the form."
    
  #Test form copying.
  Tinytest.add 'Formstack - POST /form/:id/copy', (test) ->
    resp = fstack.copyForm test_form_id
    test_form_copy_id = resp.id
    test.isTrue resp.id?
    
  #Field test setup.
  test_field_id = null
  test_field_label = "TestFieldLabel"
  test_field_type = "text"
  
  #Test field creation.
  Tinytest.add 'Formstack - POST /form/:id/field', (test) ->
    resp = fstack.createField test_form_id, 
      field_type: test_field_type
      label: test_field_label
    test.isTrue resp.id?
    test_field_id = resp.id
    
  #Test form every-field retrieval.
  Tinytest.add 'Formstack - GET form/:id/field', (test) ->
    resp = fstack.getFields test_form_id
    hasField = _.some resp, (field) -> return field.id == test_field_id
    test.isTrue hasField, "Form should contain our test field."

  #Test singular field retrieval. 
  Tinytest.add 'Formstack - GET field/:id', (test) ->
    resp = fstack.getField test_field_id
    test.equal resp.label, test_field_label, "Label of this field should be what we assigned it."
    
  #Test field modification
  # !!! This appears not to work yet. Nothing is actually changed.
  Tinytest.add 'Formstack - PUT field/:id', (test) ->
    field = fstack.getField test_field_id
    field.required = "1"
    resp = fstack.modifyField test_field_id, field
    test.equal resp.success, "1", "Should set field to required successfully."
    resp2 = fstack.getField test_field_id
    test.equal resp2.required, "1", "Required should now be set to 1. This appears to be broken on Formstack's end for the moment."
    
  #Setup submission tests
  test_submission_id = null
  test_field_id = null;
  test_content = "TEST_CONTENT"
  
  Tinytest.add 'Formstack - GET /form/:id/submissions', (test) ->
    resp = fstack.getSubmissions test_form_id
    test.equal resp.total, 0
  
  #Test submission creation
  Tinytest.add 'Formstack - POST /form/:id/submissions', (test) ->
    form = fstack.getForm test_form_id
    test_field_id = form.fields[0].id
    params = {}
    params["field_#{test_field_id}"] = test_content
    resp = fstack.createSubmission test_form_id, params
    test.isTrue resp.id?, "Should be able to create submission and get new ID."
    test_submission_id = resp.id
    
  #Test getting submissions
  Tinytest.add 'Formstack - GET /submission/:id', (test) ->
    resp = fstack.getSubmission test_submission_id
    test.isTrue (_.findWhere resp.data, {field: test_field_id, value: test_content})?, "Our value should be in the submission"
    
  #Test field deletion
  Tinytest.add 'Formstack - DELETE field/:id', (test) ->
    resp = fstack.deleteField test_field_id
    test.equal resp.success, "1", "Should delete field successfully"
    test.throws ->
      fstack.getField test_field_id
    
  #Test form deletion.
  Tinytest.add 'Formstack - DELETE /form/:id', (test) ->
    resp = fstack.deleteForm test_form_id
    test.equal resp.success, "1", "Should delete successfully."
    resp2 = fstack.deleteForm test_form_copy_id
    test.equal resp2.success, "1", "Should delete copied form successfully."
    
    
    
    
    
    
    
    
    
    
    
    
    
    