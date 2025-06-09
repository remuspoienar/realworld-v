module main

import json
import veb

@['/users']
pub fn (mut app App) user_index(mut ctx Context, user string) veb.Result {
	users := sql app.db {
		select from User
	} or { []User{} }

	return ctx.json(users)
}

struct UserPayload {
	email    string
	password string
}

@['/users'; post]
pub fn (mut app App) user_create(mut ctx Context) veb.Result {
	body := json.decode(UserPayload, ctx.req.data) or {
		ctx.res.set_status(.bad_request)
		return ctx.json({
			'error': 'Failed to decode json, error: ${err}'
		})
	}

	response := app.add_user(body.email, body.password) or {
		ctx.res.set_status(.bad_request)
		return ctx.json({
			'error': '${err}'
		})
	}

	return ctx.json(response)
}
