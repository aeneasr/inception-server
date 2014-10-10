#!/usr/bin/env bats

load discover_user

@test "~/.bosh_cache symlink" {
  run su - $TEST_USER -c "readlink ~/.bosh_cache"
  [ "${lines[0]}" = "/home/vagrant/workspace/bosh_cache" ]
}
