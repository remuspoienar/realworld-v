module api

import json
import veb

@['/articles']
pub fn (app &App) article_index(mut ctx Context) veb.Result {
	article_rows := sql app.db {
		select from Article
	} or { []Article{} }

	return ctx.json(article_rows)
}

struct ArticlePayload {
	title       string
	description string
	body        string
	tag_list    []string @[json: tagList]
}

@['/articles'; post]
pub fn (app &App) article_create(mut ctx Context) veb.Result {
	body := json.decode(struct {
		article ArticlePayload
	}, ctx.req.data) or {
		ctx.res.set_status(.bad_request)
		return ctx.json({
			'error': 'Failed to decode json, error: ${err}'
		})
	}
	author := ctx.current_user or { return resp_401(mut ctx, none) }

	response := app.add_article(body.article, author) or {
		ctx.res.set_status(.bad_request)
		return ctx.json({
			'error': '${err}'
		})
	}

	return ctx.json(response)
}
