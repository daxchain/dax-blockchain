.PHONY: dax dax-cross evm all test clean
.PHONY: dax-linux dax-linux-386 dax-linux-amd64 dax-linux-mips64 dax-linux-mips64le
.PHONY: dax-darwin dax-darwin-386 dax-darwin-amd64

GOBIN = $(shell pwd)/build/bin
GOFMT = gofmt
GO ?= 1.13.1
GO_PACKAGES = .
GO_FILES := $(shell find $(shell go list -f '{{.Dir}}' $(GO_PACKAGES)) -name \*.go)

GIT = git

dax:
	go run build/ci.go install ./cmd/dax
	@echo "Done building."d
	@echo "Run \"$(GOBIN)/dax\" to launch dax."

gc:
	go run build/ci.go install ./cmd/gc
	@echo "Done building."
	@echo "Run \"$(GOBIN)/gc\" to launch gc."

bootnode:
	go run build/ci.go install ./cmd/bootnode
	@echo "Done building."
	@echo "Run \"$(GOBIN)/bootnode\" to launch a bootnode."

puppeth:
	go run build/ci.go install ./cmd/puppeth
	@echo "Done building."
	@echo "Run \"$(GOBIN)/puppeth\" to launch puppeth."

all:
	go run build/ci.go install

test: all
	go run build/ci.go test

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# Cross Compilation Targets (xgo)

dax-cross: dax-windows-amd64 dax-darwin-amd64 dax-linux
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/dax-*

dax-linux: dax-linux-386 dax-linux-amd64 dax-linux-mips64 dax-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/dax-linux-*

dax-linux-386:
	go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/dax
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/dax-linux-* | grep 386

dax-linux-amd64:
	go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/dax
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/dax-linux-* | grep amd64

dax-linux-mips:
	go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/dax
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/dax-linux-* | grep mips

dax-linux-mipsle:
	go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/dax
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/dax-linux-* | grep mipsle

dax-linux-mips64:
	go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/dax
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/dax-linux-* | grep mips64

dax-linux-mips64le:
	go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/dax
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/dax-linux-* | grep mips64le

dax-darwin: dax-darwin-386 dax-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/dax-darwin-*

dax-darwin-386:
	go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/dax
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/dax-darwin-* | grep 386

dax-darwin-amd64:
	go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/dax
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/dax-darwin-* | grep amd64

dax-windows-amd64:
	go run build/ci.go xgo -- --go=$(GO) -buildmode=mode -x --targets=windows/amd64 -v ./cmd/dax
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/dax-windows-* | grep amd64
gofmt:
	$(GOFMT) -s -w $(GO_FILES)
	$(GIT) checkout vendor
