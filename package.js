Package.describe({
	summary: "Meteor wrapper for Formstack's REST API. Plus a bag o' tricks."
});

Package.on_use(function (api){
  api.use('coffeescript', 'server');
	api.add_files('lib/formstack.coffee', 'server');
});

Package.on_test(function (api) {
  api.use('coffeescript', 'server');
  api.use('http', 'server');
  api.add_files('lib/formstack.coffee', 'server');
  api.add_files('tests/test.coffee', 'server')
})