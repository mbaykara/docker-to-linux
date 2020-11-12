COL_RED="\033[0;31m"
COL_GRN="\033[0;32m"
COL_END="\033[0m"
LOOPDEVICE=$(shell losetup -f)

REPO=docker-to-linux


.PHONY:
debian: debian.img

.PHONY:
debian.tar:
	@make DISTR="debian" linux.tar

.PHONY:
debian.img:
	@make DISTR="debian" linux.img

linux.tar:
	@echo ${COL_GRN}"[Dump ${DISTR} directory structure to tar archive]"${COL_END}
	docker build -f ${DISTR}/Dockerfile -t ${REPO}/${DISTR} .
	docker export -o linux.tar `docker run -d ${REPO}/${DISTR} /bin/true`

linux.dir: linux.tar
	@echo ${COL_GRN}"[Extract ${DISTR} tar archive]"${COL_END}
	mkdir linux.dir
	tar -xvf linux.tar -C linux.dir

linux.img: linux.dir
	@echo ${COL_GRN}"[Create ${DISTR} disk image]"${COL_END}
	docker run -it \
		-v `pwd`:/os:rw \
		-e DISTR=${DISTR} \
		--privileged \
		--cap-add SYS_ADMIN \
		--device $(LOOPDEVICE) \
		${REPO}/builder bash /os/create_image.sh $(LOOPDEVICE)
.PHONY:
builder-interactive:
	docker run -it \
		-v `pwd`:/os:rw \
		--cap-add SYS_ADMIN \
		--device $(LOOPDEVICE) \
		${REPO}/builder bash
