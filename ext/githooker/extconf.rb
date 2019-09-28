require 'erb'
require 'fileutils'

require File.expand_path File.join(File.dirname(__FILE__), "/../../lib/githooker/version.rb")

# githooker will modify git hooks once gem is
# installed. As rubygem is not supposed to run
# arbitrary code during gem installations, we
# do trick rubygem's build process and then
# simulate successful compilation.

# modify git hooks
overwrites = %w{pre-commit pre-push pre-rebase commit-msg }
hook_dir = "#{Dir.pwd}/.git/hooks/"

unless Dir["#{hook_dir}/*"].empty?
  overwrites.each do |file|
    FileUtils.mv "#{hook_dir}/#{file}", "#{hook_dir}/#{file}.bak" if File.exist?("#{hook_dir}/#{file}")
    FileUtils.touch "#{hook_dir}/#{file}"

    version = Githooker::VERSION
    tmpl = ERB.new(
      File.read("#{File.dirname(__FILE__)}/tmpl.erb")).result(binding)

    system "echo '#{tmpl}' | cat > #{hook_dir}/#{file}"
  end
end

#create_makefile('githooker')
