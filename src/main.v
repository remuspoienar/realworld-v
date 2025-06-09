module main

import veb
import databases
import db.sqlite

const port = 8082

pub struct Context {
	veb.Context
}

pub struct App {
	db sqlite.DB
mut:
	state shared State
}

struct State {
mut:
	cnt int
}

pub fn (app &App) before_request() {
	$if trace_before_request ? {
		println('[veb] before_request: ${app.req.method} ${app.req.url}')
	}
}

fn main() {
	mut db := databases.create_db_connection() or { panic(err) }

	sql db {
		create table User
	} or { panic('error on create table: ${err}') }

	defer { db.close() or { panic(err) } }
	mut app := &App{
		db: db
	}
	veb.run_at[App, Context](mut app, port: port, family: .ip, timeout_in_seconds: 2) or {
		panic(err)
	}
}

@['/'; get]
pub fn (mut app App) ping(mut ctx Context) veb.Result {
	return ctx.text('ping')
}
