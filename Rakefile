require 'rubygems'
require 'rake/clean'
require 'rspec/core/rake_task'

CLEAN.include("")
CLOBBER.include("target")

desc "Default task prints the possible targets."
task :default do
  sh %{rake -T}
end

desc "Run puppet module RSpec tests."
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ["--format", "doc", "--color"]
  t.fail_on_error = false
  t.pattern = 'spec/**/*_spec.rb'
end

desc "Run puppet module acceptance tests."
task :acceptance do
  puts "Running acceptance tests..."
  # cucumber ? cucumber-puppet
end

desc "Check puppet module syntax."
task :syntax do
  begin
    require 'puppet/face'
  rescue LoadError
    fail 'Cannot load puppet/face, are you sure you have Puppet 2.7?'
  end

  def validate_manifest(file)
    begin
      Puppet::Face[:parser, '0.0.1'].validate(file)
    rescue Puppet::Error => error
      puts error.message
    end
  end

  
  puts "Convert DOS to Unix text file..."
  FileList['**/*'].exclude('**/pkg/**/*').each do |manifest|
      sh "dos2unix -q '#{manifest}'"
  end

  puts "Checking puppet module syntax..."
  FileList['**/*.pp'].exclude('**/pkg/**/*').each do |manifest|
      #puts "Evaluating syntax for #{manifest}"
      #validate_manifest manifest
      sh "puppet parser validate #{manifest}"
  end
end

desc "Check puppet module code style."
task :style do
  begin
    require 'puppet-lint'
  rescue LoadError
    fail 'Cannot load puppet-lint, did you install it?'
  end

  puts "Checking puppet module code style..."
  linter = PuppetLint.new
  linter.configuration.log_format = '%{path}:%{linenumber}:%{check}:%{KIND}:%{message}'

  FileList['**/*.pp'].each do |puppet_file|
    puts "Evaluating code style for #{puppet_file}"
    linter.file = puppet_file
    linter.run
  end
  fail if linter.errors?
end

# TODO: Reevaluate this when/if it becomes available in Puppet Faces
desc "Create puppet module documentation."
task :doc => [:clobber] do
  puts "Generating puppet module documentation..."
  FileUtils.mkdir_p("target/manifests")
  sh %{puppet doc --mode rdoc --manifestdir target/manifests/ --modulepath ../ --outputdir target/doc}

  work_dir = File.dirname(__FILE__)
  parent_dir = File.dirname(work_dir)

  if File.exists? "#{work_dir}/target/doc/files/#{work_dir}"
    FileUtils.mv "#{work_dir}/target/doc/files/#{work_dir}", "#{work_dir}/target/doc/files"
  end

  FileList['target/doc/**/*.html'].egrep(%r(#{parent_dir})) do |fn,line,match|
    text = File.read(fn)
    replace = text.gsub(%r(#{parent_dir}), "")
    File.open(fn, "w") { |file| file.puts replace }
  end

  FileList['target/doc/files/**/*_pp.html'].egrep(/rdoc-style\.css/) do |fn,line,match|
    depth_in_doc = fn.split(/\//).length - 3
    original_string = /[\.\/]*rdoc-style.css/
    replacement_string = '../' * depth_in_doc + 'rdoc-style.css'
    text = File.read(fn)
    replace = text.gsub(original_string, replacement_string)
    File.open(fn, "w") { |file| file.puts replace }
  end
end

desc "Create RPM package."
task :rpm => [:build] do
  puts "Creating RPM package..."
  # rpmbuild -ba / -bb
end
  
desc "Create DEB package."
task :deb => [:build] do
  puts "Creating DEB package..."
  # debuild
end

desc "Create a puppet module, compatible with Puppet Forge."
task :build do
  begin
    require 'puppet/face'
  rescue LoadError
    fail 'Cannot load puppet/face, are you sure you have Puppet 2.7?'
  end

  puts "Creating puppet module for Puppet Forge..."
  # puppet module build / upload to forge
  # Puppet::Face[:module, '1.0.0'].build()
  sh "rm -rf pkg"
  sh "cat Modulefile.in|sed -e s/##BUILD_NUMBER##/$DEV_BUILD_NUMBER/ > Modulefile"
  sh 'puppet-module build'
end

desc "Create a version tag for the current commit."
task :tag, [:version] do |t,args|
  puts "Tagging version #{args.version}"
  # git tag
  # deal with ChangeLog
end

desc "Create a puppet module release for the provided version."
task :release, [:version] => [:tag] do |t,args|
  puts "Releasing version #{args.version}"
  # checkout tag / build rpm/deb/forge package
end

namespace "jenkins" do
  begin
    require 'ci/reporter/rake/rspec'
    require 'ci/reporter/rake/cucumber'
  rescue LoadError
#    fail 'Cannot load ci_reporter, did you install it?'
  end
  
  SPEC_REPORTS_PATH = "target/reports/spec/"
  ACCEPTANCE_REPORTS_PATH = "target/reports/acceptance/"

  desc "Run Jenkins compatible Rspec tests."
  task :spec_tests => ["ci:setup:rspec"] do
    ENV["CI_REPORTS"] = SPEC_REPORTS_PATH
    FileUtils.mkdir_p(SPEC_REPORTS_PATH)
    
    Rake::Task[:spec].invoke
  end

  desc "Run Jenkins compatible acceptance tests."
  task :acceptance_tests => ["ci:setup:cucumber"] do
    ENV["CI_REPORTS"] = ACCEPTANCE_REPORTS_PATH
    FileUtils.mkdir_p(ACCEPTANCE_REPORTS_PATH)
    
    Rake::Task[:acceptance].invoke
  end
end
