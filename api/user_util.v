module api

import crypto.hmac
import crypto.sha256
import encoding.base64
import json
import time
import os

struct JwtHeader {
	alg string
	typ string
}

struct JwtPayload {
pub:
	sub         string    // (subject) = Entity to whom the token belongs, usually the user ID;
	iss         string    // (issuer) = Token issuer;
	exp         string    // (expiration) = Timestamp of when the token will expire;
	iat         time.Time // (issued at) = Timestamp of when the token was created;
	aud         string    // (audience) = Token recipient, represents the application that will use it.
	name        string
	roles       string
	permissions string
}

pub fn encode_jwt(user User) string {
	secret := os.getenv('JWT_SECRET')

	jwt_header := JwtHeader{'HS256', 'JWT'}
	jwt_payload := JwtPayload{
		sub:  '${user.id}'
		name: '${user.username}'
		iat:  time.now()
	}

	header := base64.url_encode(json.encode(jwt_header).bytes())
	payload := base64.url_encode(json.encode(jwt_payload).bytes())
	signature := base64.url_encode(hmac.new(secret.bytes(), '${header}.${payload}'.bytes(),
		sha256.sum, sha256.block_size).bytestr().bytes())

	jwt := '${header}.${payload}.${signature}'

	return jwt
}

pub fn decode_jwt(token string) !JwtPayload {
	if !validate_jwt(token) {
		return error('invalid signature')
	}

	token_parts := token.split('.')
	payload_json := base64.url_decode(token_parts[1]!).bytestr()

	return json.decode(JwtPayload, payload_json)
}

fn validate_jwt(token string) bool {
	if token == '' {
		return false
	}
	secret := os.getenv('JWT_SECRET')

	token_parts := token.split('.')
	if token_parts.len != 3 {
		return false
	}

	signature_mirror := hmac.new(secret.bytes(), '${token_parts[0]}.${token_parts[1]}'.bytes(),
		sha256.sum, sha256.block_size).bytestr().bytes()

	signature_from_token := base64.url_decode(token_parts[2])

	return hmac.equal(signature_from_token, signature_mirror)
}
