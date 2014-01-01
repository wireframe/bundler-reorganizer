require 'thor'

module Bundler
  module Reorganizer
    class CLI < Thor
      attr_accessor :sources, :rubies, :groups, :current_group

      desc "reorganize PATH_TO_GEMFILE [OPTIONS]", "reorganize Gemfile into groups of gems"
      option :output, desc: 'path to write output of reorganized Gemfile', aliases: '-o'
      def reorganize(gemfile_path)
        @sources = []
        @rubies = []
        @groups = {}

        parse gemfile_path
        output_gemfile gemfile_path
      end
      default_command :reorganize

      private

      def output_gemfile(gemfile_path)
        output_path = options[:output] || gemfile_path
        output_buffer = File.open(output_path, 'w')
        say "Writing reorganized Gemfile to: #{output_path}"

        output_buffer << sources.map {|s| "source #{stringify_arg(*s)}"}.join("\n")
        output_buffer << rubies.map {|s| "\nruby #{stringify_arg(*s)}"}.join("\n")

        groups.each do |group, gems|
          output_buffer << "\n"
          indent = group == :default ? '' : '  '
          output_buffer << "\ngroup #{stringify_args(*group)} do" unless group == :default
          gems.each do |gem_args|
            output_buffer << "\n#{indent}gem #{stringify_args(*gem_args.reject(&:empty?))}"
          end
          output_buffer << "\nend" unless group == :default
        end
        output_buffer << "\n"
      end

      # pretty print arguments as ruby parsable string
      def stringify_args(*args)
        args.map {|a| stringify_arg(a) }.join(', ')
      end

      def stringify_arg(arg)
        arg.inspect
      end

      def source(*args)
        sources << args
      end

      def ruby(*args)
        rubies << args
      end

      def gem(*args)
        options = args.last.is_a?(Hash) ? args.last : nil
        group = current_group || (options && options.delete(:group))
        group ||= :default
        groups[group] ||= []
        groups[group] << args
      end

      def group(*args, &block)
        self.current_group = args
        yield
      ensure
        current_group = nil
      end

      def parse(path)
        say "Parsing Gemfile: #{path}"
        contents = File.read path
        instance_eval contents
      end
    end
  end
end
