# frozen_string_literal: true

JWTSessions.algorithm = "HS256"
JWTSessions.signing_key = ENV["JWT_SECRET"]
JWTSessions.token_store = :memory
