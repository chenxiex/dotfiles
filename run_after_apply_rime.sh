#!/usr/bin/bash
cd ~/.config/ibus/rime
rsync -a --delete \
	--exclude='user.yaml' \
	--exclude='installation.yaml' \
	--exclude='build' \
	--exclude='*.userdb' \
	--exclude='*.custom.yaml' \
	--exclude='*.gram' \
	oh-my-rime/ .
	
