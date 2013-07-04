fstack = new Formstack {token: process.env.FORMSTACK_TEST_TOKEN}
test_form_id = null
test_form_copy_id = null
test_form_name = "METEOR_FORMSTACK_TEST"
test_form_button_title = "Test Submit Button"
Tinytest.add 'Formstack - GET /form', (test) ->
  #Authorization: Bearer <access-token>
  try
    resp = fstack.getForms()
  catch e
    test.isFalse e, "Error upon initial connection. If the code is 401, you possibly forgot to set the FORMSTACK_TEST_TOKEN environment variable. " + e
    
Tinytest.add 'Formstack - POST /form', (test) ->
  resp = fstack.createForm 
    name: test_form_name
  test.isTrue resp.id?, "Should get a new form ID when we POST /form."
  test_form_id = resp.id
  
Tinytest.add 'Formstack - PUT /form/:id', (test) ->
  resp = fstack.modifyForm test_form_id, {submit_button_title: test_form_button_title}
  test.equal resp.success, 1, "Should modify successfully."
  
Tinytest.add 'Formstack - GET /form/:id', (test) ->
  resp = fstack.getForm test_form_id
  test.equal resp.submit_button_title, test_form_button_title, "Button title should have been modified earlier."
  test.equal resp.name, test_form_name, "Should be able to retrieve the name of the form."
  
Tinytest.add 'Formstack - POST /form/:id/copy', (test) ->
  resp = fstack.copyForm test_form_id
  test_form_copy_id = resp.id
  test.isTrue resp.id?
  
Tinytest.add 'Formstack - DELETE /form/:id', (test) ->
  resp = fstack.deleteForm test_form_id
  test.equal resp.success, 1, "Should delete successfully."
  resp2 = fstack.deleteForm test_form_copy_id
  test.equal resp2.success, 1, "Should delete copied form sucessfully."