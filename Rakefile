require 'tmpdir'

def brew_install(package, *options)
  `brew list #{package}`
  return if $?.success?

  sh "brew install #{package} #{options.join ' '}"
end

def apt_install(package)
  sh "sudo apt-get install #{package}"
end

def linux?
  /linux/ =~ RUBY_PLATFORM
end

def ubuntu?
  linux? && File.exist?('/etc/lsb-release') && /Ubuntu/ =~ File.read('/etc/lsb-release')
end

def osx?
  /darwin/ =~ RUBY_PLATFORM
end

def install_github_bundle(user, package)
  unless File.exist? File.expand_path("~/.vim/bundle/#{package}")
    sh "git clone https://github.com/#{user}/#{package} ~/.vim/bundle/#{package}"
  end
end

def step(description)
  description = "-- #{description} "
  description = description.ljust(80, '-')
  puts
  puts "\e[32m#{description}\e[0m"
end

def osx_app_path(name)
  path = "/Applications/#{name}.app"
  ["~#{path}", path].each do |full_path|
    return full_path if File.directory?(full_path)
  end

  return nil
end

def app?(name)
  return !osx_app_path(name).nil?
end

def get_backup_path(path)
  number = 1
  backup_path = "#{path}.bak"
  loop do
    if number > 1
      backup_path = "#{backup_path}#{number}"
    end
    if File.exists?(backup_path) || File.symlink?(backup_path)
      number += 1
      next
    end
    break
  end
  backup_path
end

def link_file(original_filename, symlink_filename)
  original_path = File.expand_path(original_filename)
  symlink_path = File.expand_path(symlink_filename)
  if File.exists?(symlink_path) || File.symlink?(symlink_path)
    if File.symlink?(symlink_path)
      symlink_points_to_path = File.readlink(symlink_path)
      return if symlink_points_to_path == original_path
      # Symlinks can't just be moved like regular files. Recreate old one, and
      # remove it.
      ln_s symlink_points_to_path, get_backup_path(symlink_path), :verbose => true
      rm symlink_path
    else
      # Never move user's files without creating backups first
      mv symlink_path, get_backup_path(symlink_path), :verbose => true
    end
  end
  ln_s original_path, symlink_path, :verbose => true
end

namespace :install do
  namespace :osx do
    desc 'Update or Install Brew'
    task :brew do
      step 'Homebrew'
      unless system('which brew > /dev/null || ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"')
        raise "Homebrew must be installed before continuing."
      end
    end

    desc 'Install The Silver Searcher'
    task :the_silver_searcher do
      step 'the_silver_searcher'
      brew_install 'the_silver_searcher'
    end

    desc 'Install iTerm'
    task :iterm do
      step 'iterm2'
      unless app? 'iTerm'
        system <<-SHELL
          curl -L -o iterm.zip http://iterm2.googlecode.com/files/iTerm2-1_0_0_20120203.zip && \
            unzip iterm.zip && \
            mv iTerm.app /Applications && \
            rm iterm.zip
        SHELL
      end
    end

    desc 'Install ctags'
    task :ctags do
      step 'ctags'
      brew_install 'ctags'
    end

    desc 'Install reattach-to-user-namespace'
    task :reattach_to_user_namespace do
      step 'reattach-to-user-namespace'
      brew_install 'reattach-to-user-namespace'
    end

    desc 'Install tmux'
    task :tmux do
      step 'tmux'
      brew_install 'tmux'
    end

    desc 'Install MacVim'
    task :macvim do
      step 'MacVim'
      unless app? 'MacVim'
        system <<-SHELL
          curl -L -o macvim.tbz https://github.com/downloads/b4winckler/macvim/MacVim-snapshot-64.tbz && \
            bunzip2 macvim.tbz && tar xf macvim.tar && \
            mv MacVim-snapshot-64/MacVim.app /Applications && \
            rm -rf macvim.tbz macvim.tar MacVim-snapshot-64
        SHELL
        system ''
      end

      bin_vim = File.expand_path('~/bin/vim')
      FileUtils.mkdir_p(File.dirname(bin_vim))
      unless File.executable?(bin_vim)
        File.open(bin_vim, 'w', 0744) do |io|
          io << <<-SHELL
#!/bin/bash
exec /Applications/MacVim.app/Contents/MacOS/Vim "$@"
          SHELL
        end
      end
    end
  end

  namespace :ubuntu do
    desc 'Update apt-get'
    task :update do
      step 'apt-get update'
      sh "sudo apt-get update"
    end

    desc 'Install Vim'
    task :vim do
      step 'vim'
      apt_install 'vim'
    end

    desc 'Install tmux'
    task :tmux do
      step 'tmux'
      apt_install 'tmux'
    end

    desc 'Install ctags'
    task :ctags do
      step 'ctags'
      apt_install 'ctags'
    end

    # https://github.com/ggreer/the_silver_searcher
    task :the_silver_searcher do
      step 'the_silver_searcher'
      sh 'sudo apt-get install build-essential automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev'
      Dir.mktmpdir do |dir|
        sh "cd #{dir} && git clone https://github.com/ggreer/the_silver_searcher.git && cd the_silver_searcher && ./build.sh && sudo make install"
      end
    end

    # instructions from http://www.webupd8.org/2011/04/solarized-must-have-color-paletter-for.html
    desc 'Install Solarized and fix ls'
    task :solarized, :arg1 do |t, args|
      step 'installing solarized color theme'
      color = (["dark", "light"].include?(args[:arg1]) ? args[:arg1] : "dark")

      step 'solarized'
      Dir.mktmpdir do |dir|
        sh "cd #{dir} && git clone https://github.com/sigurdga/gnome-terminal-colors-solarized.git && cd gnome-terminal-colors-solarized && ./solarize #{color}"
      end

      step 'fix ls-colors'
      Dir.chdir do
        sh "wget --no-check-certificate https://raw.github.com/seebi/dircolors-solarized/master/dircolors.ansi-#{color}"
        sh "mv dircolors.ansi-#{color} .dircolors"
        sh 'eval `dircolors .dircolors`'
      end
    end
  end

  desc 'Install Vundle'
  task :vundle do
    step 'vundle'
    install_github_bundle 'gmarik','vundle'
    sh 'vim -c "BundleInstall" -c "q" -c "q"'
  end
end

desc 'Install these config files.'
task :default do
  if ubuntu?
    Rake::Task['install:ubuntu:update'].invoke
    Rake::Task['install:ubuntu:vim'].invoke
    Rake::Task['install:ubuntu:tmux'].invoke
    Rake::Task['install:ubuntu:ctags'].invoke
    Rake::Task['install:ubuntu:the_silver_searcher'].invoke
  elsif osx?
    Rake::Task['install:osx:brew'].invoke
    Rake::Task['install:osx:the_silver_searcher'].invoke
    Rake::Task['install:osx:iterm'].invoke
    Rake::Task['install:osx:ctags'].invoke
    Rake::Task['install:osx:reattach_to_user_namespace'].invoke
    Rake::Task['install:osx:tmux'].invoke
    Rake::Task['install:osx:macvim'].invoke
  else
    fail('Sorry, your system is not supported.')
  end

  # TODO install gem ctags?
  # TODO run gem ctags?

  step 'symlink'
  link_file 'vim'                   , '~/.vim'
  link_file 'tmux.conf'             , '~/.tmux.conf'
  link_file 'vimrc'                 , '~/.vimrc'
  link_file 'vimrc.bundles'         , '~/.vimrc.bundles'
  unless File.exist?(File.expand_path('~/.vimrc.local'))
    cp File.expand_path('vimrc.local'), File.expand_path('~/.vimrc.local'), :verbose => true
  end
  unless File.exist?(File.expand_path('~/.vimrc.bundles.local'))
    cp File.expand_path('vimrc.bundles.local'), File.expand_path('~/.vimrc.bundles.local'), :verbose => true
  end

  # Install Vundle and bundles
  Rake::Task['install:vundle'].invoke

  if ubuntu?
    step 'solarized dark or light'
    puts
    puts " You're almost done! Inside of the maximum-awesome directory, do: "
    puts "   rake install:ubuntu:solarized['dark'] "
    puts "     or                           "
    puts "   rake install:ubuntu:solarized['light']"
    puts " You may need to close your terminal and re-open it for it to take effect."
  elsif osx?
    step 'iterm2 colorschemes'
    colorschemes = `defaults read com.googlecode.iterm2 'Custom Color Presets'`
    dark  = colorschemes !~ /Solarized Dark/
    light = colorschemes !~ /Solarized Light/
    sh('open', '-a', '/Applications/iTerm.app', File.expand_path('iterm2-colors-solarized/Solarized Dark.itermcolors')) if dark
    sh('open', '-a', '/Applications/iTerm.app', File.expand_path('iterm2-colors-solarized/Solarized Light.itermcolors')) if light

    step 'iterm2 profiles'
    puts
    puts "  Your turn!"
    puts
    puts "  Go and manually set up Solarized Light and Dark profiles in iTerm2."
    puts "  (You can do this in 'Preferences' -> 'Profiles' by adding a new profile,"
    puts "  then clicking the 'Colors' tab, 'Load Presets...' and choosing a Solarized option.)"
    puts "  Also be sure to set Terminal Type to 'xterm-256color' in the 'Terminal' tab."
    puts
    puts "  Enjoy!"
  end
end
