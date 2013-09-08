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

  # https://github.com/ggreer/the_silver_searcher
  desc 'Install The Silver Searcher'
  task :the_silver_searcher do
    step 'the_silver_searcher'
    sh 'sudo apt-get install build-essential automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev'
    sh 'git clone https://github.com/ggreer/the_silver_searcher.git'
    Dir.chdir 'the_silver_searcher' do
      sh './build.sh'
      sh 'sudo make install'
    end
  end

  # instructions from http://www.webupd8.org/2011/04/solarized-must-have-color-paletter-for.html
  desc 'Install Solarized and fix ls'
  task :solarized, :arg1 do |t, args|
    args[:arg1] = "dark" unless ["dark", "light"].include? args[:arg1]
    color = ["dark", "light"].include?(args[:arg1]) ? args[:arg1] : "dark"

    step 'solarized'
    sh 'git clone https://github.com/sigurdga/gnome-terminal-colors-solarized.git' unless File.exist? 'gnome-terminal-colors-solarized'
    Dir.chdir 'gnome-terminal-colors-solarized' do
      sh "./solarize #{color}"
    end

    step 'fix ls-colors'
    Dir.chdir do
      sh "wget --no-check-certificate https://raw.github.com/seebi/dircolors-solarized/master/dircolors.ansi-#{color}"
      sh "mv dircolors.ansi-#{color} .dircolors"
      sh 'eval `dircolors .dircolors`'
    end
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

  step 'solarized dark or light'
  puts
  puts " You're almost done! Inside of the maximum-awesome-linux directory, do: "
  puts "   rake install:solarized['dark'] "
  puts "     or                           "
  puts "   rake install:solarized['light']"

  puts " You may need to close your terminal and re-open it for it to take effect."
end
