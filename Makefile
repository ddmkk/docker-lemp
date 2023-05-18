include .env
local:
	UID=${UID} GID=${GID} docker-compose -f docker-compose.yml up
locald:
	UID=${UID} GID=${GID} docker-compose -d docker-compose.yml up
