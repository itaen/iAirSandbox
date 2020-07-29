# pre setting
#brew install rvm
#
#cd /projectDirectory
#
##create rvmrc
#rvm --rvmrc --create ruby-v.e.r.s.i.o.n@project_name
#
#gem install bundler
#
##create gemfile, add gem dependencies in gem file
## gem 'cocoapods', '~> 1.9.3'
#
## create podfile
#
## create shell script for pod install
#
#bundle install
#bundle exec pod install --verbose --no-repo-update

# then sh pod_install.sh every time environment changes

bundle install
bundle exec pod install --verbose --no-repo-update
