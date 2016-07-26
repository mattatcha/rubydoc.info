#!/usr/bin/env puma

root = File.dirname(__FILE__) + '/../'

directory root
rackup root + 'config.ru'
environment 'production'
bind 'tcp://0.0.0.0:8080'

unless ENV['DOCKERIZED']
  daemonize unless $stdout.tty?
  pidfile root + 'tmp/pids/server.pid'
end

unless $stdout.tty?
  stdout_redirect root + 'log/puma.log', root + 'log/puma.err.log', true
end

threads 8, 32
workers 3
