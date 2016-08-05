#!/bin/sh

# Shamelessly copied from http://goo.gl/oR7beo
ps aux | grep 'sshd:' | awk '{print $2}' | xargs kill

# Install common dependencies
