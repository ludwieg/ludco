.PHONY: templates

compiler: templates
	@mkdir -p bin \
	&& go build -ldflags "-s -w -X main.build_date=`date +"%Y%m%d.%H%M%S"`" -o bin/ludco

install:
	cp bin/ludco /usr/local/bin

parser/parser.go:
	pigeon -o parser/parser.go parser/lud.peg

templates:
	@if [ -d templates ]; then \
		cd templates \
		&& git reset --hard HEAD >/dev/null \
		&& git pull --rebase >/dev/null \
		&& cd ..; \
	else \
		git clone https://github.com/ludwieg/golang.git templates; \
	fi; \
	support/gocat.sh "./templates/impl" "./templates/impl" "impl" \
	&& tail -n +2 "./templates/impl/ludwieg_base.go" > "./templates/impl/ludwieg_base.go.tmp" \
	&& echo "// WARNING: This file is automatically generated. DO NOT EDIT.\n\npackage langs\n\nconst golangBaseFile = \``base64 < "./templates/impl/ludwieg_base.go.tmp"`\`\n" > langs/go_base.go \
	&& rm ./templates/impl/ludwieg_base.go

deps:
	dep ensure
