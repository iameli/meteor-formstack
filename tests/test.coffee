fstack = new Formstack {token: process.env.FORMSTACK_TEST_TOKEN}
test_form_id = null
test_form_name = "METEOR_FORMSTACK_TEST"
Tinytest.add 'Formstack - GET /form', (test) ->
  #Authorization: Bearer <access-token>
  try
    resp = fstack.getForms()
  catch e
    test.isFalse e, "Error upon initial connection. If the code is 401, you possibly forgot to set the FORMSTACK_TEST_TOKEN environment variable. " + e
    
Tinytest.add 'Formstack - POST /form', (test) ->
  resp = fstack.createForm 
    name: test_form_name
  test.isTrue resp.data.id?, "Should get a new form ID when we POST /form."
  test_form_id = resp.data.id
  
Tinytest.add 'Formstack - GET /form/:id', (test) ->
  resp = fstack.getForm test_form_id
  test.equal resp.data.name, test_form_name, "Should be able to retrieve the name of the form."
  
Tinytest.add 'Formstack - DELETE /form/:id', (test) ->
  resp = fstack.deleteForm test_form_id
  test.equal resp.data.success, 1, "Should delete successfully."