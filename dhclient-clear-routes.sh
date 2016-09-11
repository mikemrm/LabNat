#!/bin/bash
case $reason in
	BOUND|RENEW|REBIND|REBOOT)
		unset new_routers
	;;
esac

