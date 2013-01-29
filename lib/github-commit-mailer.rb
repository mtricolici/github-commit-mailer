require "github-commit-mailer/version"

module Github
  module Commit
    module Mailer
        class ConfigException < Exception
	end

    	class GithubCommitMailer
	   def initialize(repo_dir, yml_cfg, last_commit_file)
	      @repo_dir = repo_dir
	      @yml_cfg = yml_cfg
	      @last_commit_file = last_commit_file

	      validate
	   end

	   def run
	      last_rev = get_last_emailed_commit
	      git_pull
	      revs = get_new_commits(last_rev)

	      if revs.length < 2 then
	         puts "No new commits. Exiting."
		 return
	      end

	      puts "Emailing the following commits:"
	      revs.each { |r|
	         puts "commit: '#{r}'"
	      }

	      rev_from = revs[revs.length - 1]
	      rev_to   = revs[0]

	      cmd = "cd #{@repo_dir} && echo '#{rev_from} #{rev_to} refs/heads/master'|git-commit-notifier #{@yml_cfg}; cd -"
	      puts "#{cmd}"
	      raise "Error executing git-commit-notifier" if !system(cmd)

	      puts "Saving '#{rev_to}' to '#{@last_commit_file}' ..."
	      File.open(@last_commit_file, 'w') do |f|
	         f.puts "#{rev_to}"
	      end
	   end

	   private
	   def validate
	      raise ConfigException, "Git repository directory doesn't exist" if Dir[@repo_dir] == nil
	      raise ConfigException, "Yaml config file doesn't exist" if !File.exists?(@yml_cfg)
	   end

	   def get_last_emailed_commit
	      last_rev = nil

	      if File.exists? @last_commit_file then
	         last_rev = File.readlines(@last_commit_file)[0].strip
		 puts "Last emailed revision '#{last_rev}'"
	      end

	      last_rev
	   end

	   def git_pull
	      res = system("cd #{@repo_dir} && git pull --rebase ; cd -")
	      raise "Error executing git_pull" if !res
	   end

	   def get_new_commits(last_rev)
	      revs = []

	      IO.popen "git --git-dir #{@repo_dir}/.git log -200|grep -e '^commit '|awk '{print $2}'" do |io|
	         io.each do |line|
		    if last_rev.nil? or ! revs.include? last_rev then
		        revs << line.strip
		    end
		 end
	      end

	      revs
	   end

	end
    end
  end
end
