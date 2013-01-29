#!/usr/bin/env ruby

require 'rubygems'
require 'github-commit-mailer'

repo_dir = "/home/mtricolici/Projects/Converse/confoo"
yml_cfg = "/home/mtricolici/Projects/Deploy/github-commit-mailer/example/git-commit-notifier.yml"
last_commit_file = "/tmp/confoo-last_commit_rev"

mailer = Github::Commit::Mailer::GithubCommitMailer.new(repo_dir, yml_cfg, last_commit_file)
mailer.run

