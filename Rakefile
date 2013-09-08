require 'tmpdir'

def step(description)
  description = "-- #{description} "
  description = description.ljust(80, '-')
  puts
  puts "\e[32m#{description}\e[0m"
end

def app_path(name)
  path = "/Applications/#{name}.app"
  ["~#{path}", path].each do |full_path|
    return full_path if File.directory?(full_path)
  end

  return nil
end

def app?(name)
  return !app_path(name).nil?
end

def link_file(original_filename, symlink_filename)
  original_path = File.expand_path(original_filename)
  symlink_path = File.expand_path(symlink_filename)
  if File.exists?(symlink_path)
    # Symlink already configured properly. Leave it alone.
    return if File.symlink?(symlink_path) and File.readlink(symlink_path) == original_path
    # Never move user's files without creating backups first
    number = 1
    loop do
      backup_path = "#{symlink_path}.bak"
      if number > 1
        backup_path = "#{backup_path}#{number}"
      end
      if File.exists?(backup_path)
        number += 1
        next
      end
      mv symlink_path, backup_path, :verbose => true
      break
    end
  end
  ln_s original_path, symlink_path, :verbose => true
end

namespace :install do

  desc 'Apt-get Update'
  task :update do
    step 'apt-get update'
    sh 'sudo apt-get update'
  end

  desc 'Install Vim'
  task :vim do
    step 'vim'
    sh 'sudo apt-get install vim'
  end

  desc 'Install tmux'
  task :tmux do
    step 'tmux'
    sh 'sudo apt-get install tmux'
  end

  desc 'Install ctags'
  task :ctags do
    step 'ctags'
    sh 'sudo apt-get install ctags'
  end

  # TODO this only works for 13.04, as per instructions here
  # https://github.com/ggreer/the_silver_searcher
  desc 'Install The Silver Searcher'
  task :the_silver_searcher do
    step 'the_silver_searcher'
    sh 'sudo apt-get install software-properties-common'
    sh 'sudo apt-add-repository ppa:mizuno-as/silversearcher-ag'
    Rake::Task['install:update'].invoke
    sh 'sudo apt-get install silversearcher-ag'
  end

  # instructions from http://www.webupd8.org/2011/04/solarized-must-have-color-paletter-for.html
  desc 'Install Solarized'
  task :solarized do
    step 'solarized'
    sh 'git clone https://github.com/sigurdga/gnome-terminal-colors-solarized.git'
  end
end

desc 'Install these config files.'
task :default do
  Rake::Task['install:update'].invoke
  Rake::Task['install:vim'].invoke
  Rake::Task['install:tmux'].invoke
  Rake::Task['install:ctags'].invoke
  Rake::Task['install:the_silver_searcher'].invoke

  step 'git submodules'
  sh 'git submodule update --init'

  # TODO install gem ctags?
  # TODO run gem ctags?

  step 'symlink'
  link_file 'vim'       , '~/.vim'
  link_file 'tmux.conf' , '~/.tmux.conf'
  link_file 'vimrc'     , '~/.vimrc'
  unless File.exist?(File.expand_path('~/.vimrc.local'))
    cp File.expand_path('vimrc.local'), File.expand_path('~/.vimrc.local'), :verbose => true
  end

  step 'solarized color scheme'
  Rake::Task['install:solarized'].invoke

  step 'fix ls-colors'
  Dir.chdir do
    sh 'wget --no-check-certificate https://raw.github.com/seebi/dircolors-solarized/master/dircolors.ansi-dark'
    sh 'mv dircolors.ansi-dark .dircolors'
    sh 'eval `dircolors .dircolors`'
  end

  step 'solarized dark or light'
  puts
  puts " Now, you'll have to go into the maximum-awesome directory and do"
  puts " cd gnome-terminal-colors-solarized "
  puts " ./solarize dark # i'll get light working in a bit. "
end
