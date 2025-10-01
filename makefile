all: dev

dev:
	npx elm-watch hot

build:
	elm make src/Main.elm  --output=static/app.js

build-opt:
	elm make src/Main.elm  --output=static/app.js --optimize

web:
	python -m http.server 8080
