module api

@[table: 'articles']
pub struct Article {
pub mut:
	id          int    @[primary; serial]
	author_id   int    @[required]
	slug        string @[required; unique]
	title       string @[required]
	description string @[required]
	body        string @[required]
	created_at  string @[default: 'CURRENT_TIMESTAMP']
	updated_at  string @[default: 'CURRENT_TIMESTAMP']
}
