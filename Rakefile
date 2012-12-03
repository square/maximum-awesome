def brew_install(package, *options)
  Rake::Task['brew_update'].invoke

  `brew list #{package}`
  return if $?.success?

  sh "brew install #{package} #{options.join ' '}"
end

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

task :brew_update do
  `brew update`
end

namespace :install do
  desc 'Install Ack'
  task :ack do
    step 'ack'
    brew_install 'ack'
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

desc 'Install these config files.'
task :default do
  Rake::Task['install:ack'].invoke
  Rake::Task['install:iterm'].invoke
  Rake::Task['install:ctags'].invoke
  Rake::Task['install:reattach_to_user_namespace'].invoke
  Rake::Task['install:tmux'].invoke
  Rake::Task['install:macvim'].invoke

  step 'git submodules'
  sh 'git submodule update --init'

  step 'command-t'
  Dir.chdir 'vim/bundle/command-t' do
    sh 'env PATH=/bin:/usr/bin rake make'
  end

  # TODO install gem ctags?
  # TODO run gem ctags?

  step 'symlink'
  rm_rf File.expand_path('~/.vim')
  ln_sf File.expand_path('tmux.conf'),    File.expand_path('~/.tmux.conf'),    :verbose => true
  ln_sf File.expand_path('vim'),          File.expand_path('~/.vim'),          :verbose => true
  ln_sf File.expand_path('vimrc'),        File.expand_path('~/.vimrc'),        :verbose => true

  unless File.exist?(File.expand_path('~/.vimrc.local'))
    cp File.expand_path('vimrc.local'), File.expand_path('~/.vimrc.local'), :verbose => true
  end

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
  puts "  Be sure to set Terminal Type to 'xterm-256color' in the 'Terminal' tab."
  puts
  puts "  Enjoy!"
  puts
end
