require 'thor'

module Bundler
  module Reorganizer
    class CLI < Thor::Group
      DEFAULT_GROUP = [:default]
      attr_accessor :sources, :rubies, :groups, :current_group

      desc "reorganize Gemfile into groups of gems"
      argument :gemfile_path, :banner=>"path/to/Gemfile"
      class_option :output, desc: 'path to write output of reorganized Gemfile', aliases: '-o'
      def reorganize
        @sources = []
        @rubies = []
        @groups = {}

        parse_gemfile
        output_gemfile
      end

      private

      def output_gemfile
        output_path = options[:output] || gemfile_path
        output_buffer = File.open(output_path, 'w')
        say "Writing reorganized Gemfile to: #{output_path}"

        output_buffer << sources.map {|s| "source #{stringify_arg(*s)}"}.join("\n")
        output_buffer << rubies.map {|s| "\nruby #{stringify_arg(*s)}"}.join("\n")

        groups.each do |group, gems|
          output_buffer << "\n"
          indent = group == DEFAULT_GROUP ? '' : '  '
          output_buffer << "\ngroup #{stringify_args(*group)} do" unless group == DEFAULT_GROUP
          gems.sort_by!(&:first)
          gems.each do |gem_args|
            output_buffer << "\n#{indent}gem #{stringify_args(*gem_args.reject(&:empty?))}"
          end
          output_buffer << "\nend" unless group == DEFAULT_GROUP
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
        options = args.last.is_a?(Hash) ? args.last : {}
        group = current_group || options.delete(:group) || DEFAULT_GROUP
        group = wrap_in_array(group).sort
        groups[group] ||= []
        groups[group] << args
      end

      def group(*args, &block)
        self.current_group = args
        yield
      ensure
        self.current_group = nil
      end

      def wrap_in_array(object)
        object.is_a?(Array) ? object : [object]
      end

      def parse_gemfile
        say "Parsing Gemfile: #{gemfile_path}"
        contents = File.read gemfile_path
        instance_eval contents
      end
    end
  end
end
