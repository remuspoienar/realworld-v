module main

import veb
import os
import api
import database

const port = (os.getenv_opt('PORT') or { '8082' }).int()

fn main() {
	mut db := database.create_db_connection() or { panic(err) }

	sql db {
		create table api.User
		create table api.Article
	} or { panic('error on create table: ${err}') }

	defer { db.close() or { panic(err) } }

	mut app := &api.App{
		db: db
	}

	app.use(handler: api.logger)
	app.use(handler: app.try_set_current_user)

	// mut user_routes := &ap.App{app}
	// app.register_controller[users.App, common.Context]('/users', mut user_routes)!

	// mut article_routes := &articles.App{app}
	// app.register_controller[articles.App, common.Context]('/articles', mut article_routes)!

	veb.run_at[api.App, api.Context](mut app, port: port) or { panic(err) }
}
