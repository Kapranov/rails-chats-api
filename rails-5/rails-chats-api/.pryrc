if Rails.env.development? || Rails.env.test?
  extend Hirb::Console
end

# === EDITOR ===
Pry.editor = 'vim'

# == Pry-Nav - Using pry as a debugger ==
Pry.commands.alias_command 'c', 'continue' rescue nil
Pry.commands.alias_command 's', 'step' rescue nil
Pry.commands.alias_command 'n', 'next' rescue nil

# === CUSTOM PROMPT ===
Pry.prompt = [proc { |obj, nest_level, _| "#{RUBY_VERSION} (#{obj}):#{nest_level} > " }, proc { |obj, nest_level, _| "#{RUBY_VERSION} (#{obj}):#{nest_level} * " }]

# === Listing config ===
Pry.config.ls.separator = "\n"
Pry.config.ls.heading_color = :magenta
Pry.config.ls.public_method_color = :green
Pry.config.ls.protected_method_color = :yellow
Pry.config.ls.private_method_color = :bright_black

# == PLUGINS ===
begin
  require 'rubygems'
  require 'awesome_print'

  AwesomePrint.defaults={:theme=>:solorized}
  Pry.config.print = proc { |output, value| output.puts value.ai }
end

# === CONVENIENCE METHODS ===
class Array
  def self.toy(n=10, &block)
    block_given? ? Array.new(n,&block) : Array.new(n) {|i| i+1}
  end
end

class Hash
  def self.toy(n=10)
    Hash[Array.toy(n).zip(Array.toy(n){|c| (96+(c+1)).chr})]
  end
end
