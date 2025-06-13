module api

pub fn (app &App) add_article(body ArticlePayload, author User) !Article {
	slug := str_to_slug(body.title)
	article := Article{
		author_id:   author.id
		title:       body.title
		description: body.description
		body:        body.body
		slug:        slug
	}

	id := sql app.db {
		insert article into Article
	} or {
		eprintln(err)
		return err
	}

	return sql app.db {
		select from Article where id == id limit 1
	}!.first()
}
