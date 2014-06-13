require 'sinatra'
require 'sinatra/json'

get '/example.json' do
	json data: [2,2,3,4,5,6,7,8,9,10]
end

[{"id":1,"created_at":"2014-06-13T10:06:48.733Z","updated_at":"2014-06-13T10:06:48.733Z","title":"Eat the world","deadline":"2014-08-30","difficulty":10,"importance":8,"done":false,"completedAt":null,"user_id":1,"description":"seriously, like, everything.","category":10},
	{"id":2,"created_at":"2014-06-13T10:07:36.715Z","updated_at":"2014-06-13T10:07:36.715Z","title":"Make a task manager ","deadline":"2014-06-19","difficulty":5,"importance":5,"done":false,"completedAt":null,"user_id":1,"description":"why has no one ever made one of these??","category":6},
	{"id":3,"created_at":"2014-06-13T10:08:19.428Z","updated_at":"2014-06-13T10:08:19.428Z","title":"Get money","deadline":"2014-06-13","difficulty":2,"importance":9,"done":false,"completedAt":null,"user_id":1,"description":"Get paid","category":7},
	{"id":4,"created_at":"2014-06-13T10:09:37.141Z","updated_at":"2014-06-13T10:09:37.141Z","title":"Eat a sandwich","deadline":"2014-06-13","difficulty":1,"importance":6,"done":false,"completedAt":null,"user_id":1,"description":"possibly mergeable with 'eat everything'","category":3},
	{"id":5,"created_at":"2014-06-13T10:10:43.953Z","updated_at":"2014-06-13T10:10:43.953Z","title":"Save Gotham city","deadline":"2014-06-15","difficulty":2,"importance":10,"done":false,"completedAt":null,"user_id":1,"description":"That darn Jokester again!","category":7},
	{"id":6,"created_at":"2014-06-13T10:11:59.486Z","updated_at":"2014-06-13T10:11:59.486Z","title":"Destroy Gotham city","deadline":"2014-06-15","difficulty":3,"importance":10,"done":false,"completedAt":null,"user_id":1,"description":"Tee hee! That bats man will never know!","category":7},
	{"id":7,"created_at":"2014-06-13T10:13:00.933Z","updated_at":"2014-06-13T10:13:00.933Z","title":"Laundry","deadline":"2014-06-16","difficulty":4,"importance":4,"done":false,"completedAt":null,"user_id":1,"description":"the stonk is too stronk","category":null}]