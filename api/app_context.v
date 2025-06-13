module api

import veb
import db.sqlite

pub struct Context {
	veb.Context
mut:
	current_user ?User
}

pub fn (mut ctx Context) not_found() veb.Result {
	ctx.res.set_status(.not_found)
	return ctx.html('<h1>Realworld: Page not found!</h1>')
}

pub struct App {
	veb.Middleware[Context]
	veb.Controller
pub:
	db sqlite.DB
}

pub fn (app &App) try_set_current_user(mut ctx Context) bool {
	auth_header := (ctx.get_header(.authorization) or { return true })

	token := auth_header.split('Token ')[1] or { return halt_401(mut ctx, none) }
	payload := decode_jwt(token) or { return halt_401(mut ctx, none) }

	user_id := payload.sub.int()

	if user_id == 0 {
		return halt_401(mut ctx, none)
	}

	user_rows := sql app.db {
		select from User where id == user_id limit 1
	} or { return true }

	ctx.current_user = user_rows.first()
	return true
}

pub fn logger(mut ctx Context) bool {
	println('[${ctx.req.method}] ${ctx.req.url}')
	return true
}

@['/'; get]
pub fn (app &App) ping(mut ctx Context) veb.Result {
	return ctx.text('ping')
}
