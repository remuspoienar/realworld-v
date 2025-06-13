module api

@[table: 'users']
pub struct User {
pub mut:
	id         int    @[primary; serial]
	email      string @[required; unique]
	username   string @[required; unique]
	password   string @[required; json: '-']
	bio        string @[default: '`Content creator @ Conduit`']
	image      string @[default: '`https://api.realworld.io/images/smiley-cyrus.jpeg`']
	created_at string @[default: 'CURRENT_TIMESTAMP']
	updated_at string @[default: 'CURRENT_TIMESTAMP']

	articles []Article @[fkey: 'author_id']
}
