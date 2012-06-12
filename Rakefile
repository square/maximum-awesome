def brew_install(*packages)
  uninstalled = packages.select do |package|
    `brew list #{package}`
    !$?.success?
  end

  if uninstalled.any?
    sh "brew install #{uninstalled.join(' ')}"
  end
end

def step(description)
  description = "-- #{description} "
  description = description.ljust(80, '-')
  puts "\e[32m#{description}\e[0m"
end

desc 'Install these config files.'
task :default do
  step 'brew'
  brew_install 'ctags', 'macvim', 'reattach-to-user-namespace', 'tmux'

  step 'git submodules'
  sh 'git submodule update --init'

  step 'command-t'
  Dir.chdir 'vim/bundle/command-t' do
    sh "rake make"
  end

  # include solarized colorschemes for iTerm2, and configure them?
  # install gem ctags?
  # run gem ctags?

  step 'git templates'
  sh "git config --global init.templatedir #{File.expand_path('git_template')}"

  step 'symlink'
  rm_rf File.expand_path('~/.vim')
  ln_sf File.expand_path('tmux.conf'), File.expand_path('~/.tmux.conf'), :verbose => true
  ln_sf File.expand_path('vim'),       File.expand_path('~/.vim'),       :verbose => true
  ln_sf File.expand_path('vimrc'),     File.expand_path('~/.vimrc'),     :verbose => true

  step 'iterm2 colorschemes'
  sh 'open', File.expand_path('iterm2-colors-solarized/Solarized Dark.itermcolors')
  sh 'open', File.expand_path('iterm2-colors-solarized/Solarized Light.itermcolors')
end
