module api

import veb

fn halt_401(mut ctx Context, message ?string) bool {
	ctx.res.set_status(.unauthorized)
	ctx.json({
		'error': message or { 'Empty, missing of malformed token' }
	})
	return false
}

fn resp_401(mut ctx Context, message ?string) veb.Result {
	ctx.res.set_status(.unauthorized)
	return ctx.json({
		'error': message or { 'Empty, missing of malformed token' }
	})
}

fn halt_400(mut ctx Context, message string) bool {
	ctx.res.set_status(.bad_request)
	ctx.json({
		'error': message
	})
	return false
}

fn resp_400(mut ctx Context, message string) veb.Result {
	ctx.res.set_status(.bad_request)
	return ctx.json({
		'error': message
	})
}

fn str_to_slug(str string) string {
	return str.trim_space().to_lower().split_by_space().join('-')
}
