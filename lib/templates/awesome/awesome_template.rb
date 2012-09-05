require 'fileutils'
# require 'syntax/convertors/html'
require 'coderay'
require 'pathname'

class AwesomeTemplate < MetricFu::Template

  def write
    # Getting rid of the crap before and after the project name from integrity
    # @name = File.basename(Dir.pwd).gsub(/^\w+-|-\w+$/, "")
    @name = Pathname.new(Dir.pwd).basename

    # Copy Bluff javascripts to output directory
    Dir[File.join(this_directory, '..', 'javascripts', '*')].each do |f|
      FileUtils.copy(f, File.join(MetricFu.output_directory, File.basename(f)))
    end

    report.each_pair do |section, contents|
      if template_exists?(section)
        create_instance_var(section, contents)
        create_instance_var(:per_file_data, per_file_data)
        @html = erbify(section)
        html = erbify('layout')
        fn = output_filename(section)
        MetricFu.report.save_output(html, MetricFu.output_directory, fn)
      end
    end

    # Instance variables we need should already be created from above
    if template_exists?('index')
      @html = erbify('index')
      html = erbify('layout')
      fn = output_filename('index')
      MetricFu.report.save_output(html, MetricFu.output_directory, fn)
    end

    write_file_data
  end

  def convert_ruby_to_html(ruby_text)
    # convertor = Syntax::Convertors::HTML.for_syntax('ruby')
    # convertor.convert(ruby_text)
    tokens = CodeRay.scan(ruby_text, :ruby)
    tokens.div( :line_numbers => :table, :css => :class, :style => :alpha )
    # :tab_width – tabulation width in spaces. Default: 8
# :css – how to include the styles (:class и :style). Default: :class)
# 
# :wrap – wrap result in html tag :page, :div, :span or not to wrap (nil)
# 
# :line_numbers – how render line numbers (:table, :inline, :list or nil)
# 
# :line_number_start – first line number
# 
# :bold_every – make every n-th line number bold. Default: 10
# CodeRay, as Syntax may be used to analyze source code, because object Tokens is a list of tokens with specified types.
  end
  def write_file_data

    per_file_data.each_pair do |file, lines|
      data = File.open(file, 'r').readlines
      fn = "#{file.gsub(%r{/}, '_')}.html"

      out = "<html><head><style>#{inline_css('css/syntax.css')}</style></head><body>"
      out << "<table cellpadding='0' cellspacing='0' class='ruby'>"
      data.each_with_index do |line, idx|
        out << "<tr><td valign='top'><small>#{idx + 1}</small></td>"
        out << "<td valign='top'>"
        if lines.has_key?((idx + 1).to_s)
          out << "<ul>"
          lines[(idx + 1).to_s].each do |problem|
            out << "<li>#{problem[:description]} &raquo; #{problem[:type]}</li>"
          end
          out << "</ul>"
        else
          out << "&nbsp;"
        end
        out << "</td>"
        line_for_display = MetricFu.configuration.syntax_highlighting ? convert_ruby_to_html(line) : line
        out << "<td valign='top'><a name='line#{idx + 1}'>#{line_for_display}</a></td>"
        out << "</tr>"
      end
      out << "<table></body></html>"

      MetricFu.report.save_output(out, MetricFu.output_directory, fn)
    end
  end

  def this_directory
    File.dirname(__FILE__)
  end
end

