setup:
	mkdir build
	cd web; \
	yarn

.PHONY: build
build: 
	cd server; \
	cargo build --release
	cp ./server/target/release/files build/
	cd web; \
	yarn build
	cp -r ./web/public ./build/web

dev: 
	make -j 2 devserver devweb

devserver:
	cd server; \
	cargo run

devweb:
	cd web; \
	yarn dev
