require 'activesupport'

module MetricFu
  class Grapher
    BLUFF_GRAPH_SIZE = "1000x400"
  end
  
  class FlayBluffGrapher < FlayGrapher
    def graph!
      content = <<-EOS
        var g = new Bluff.Line('graph', "#{BLUFF_GRAPH_SIZE}");
        g.theme_pastel();
        g.title = 'Flay: duplication';
        g.data('flay', [#{@flay_score.join(',')}]);
        g.labels = #{@labels.to_json};
        g.draw();
      EOS
      File.open(File.join(MetricFu.output_directory, 'flay.js'), 'w') {|f| f << content }
    end
  end

  class FlogBluffGrapher < FlogGrapher
    def graph!
      content = <<-EOS
        var g = new Bluff.Line('graph', "#{BLUFF_GRAPH_SIZE}");
        g.theme_pastel();
        g.title = 'Flog: code complexity';
        g.data('average', [#{@flog_average.join(',')}]);
        g.data('top 5% average', [#{@top_five_percent_average.join(',')}])
        g.labels = #{@labels.to_json};
        g.draw();
      EOS
      File.open(File.join(MetricFu.output_directory, 'flog.js'), 'w') {|f| f << content }
    end
  end

  class RcovBluffGrapher < RcovGrapher
    def graph!
      content = <<-EOS
        var g = new Bluff.Line('graph', "#{BLUFF_GRAPH_SIZE}");
        g.theme_pastel();
        g.title = 'Rcov: code coverage';
        g.data('rcov', [#{@rcov_percent.join(',')}]);
        g.labels = #{@labels.to_json};
        g.draw();
      EOS
      File.open(File.join(MetricFu.output_directory, 'rcov.js'), 'w') {|f| f << content }
    end
  end

  class ReekBluffGrapher < ReekGrapher
    def graph!
      legend = @reek_count.keys.sort
      data = ""
      legend.each do |name|
        data += "g.data('#{name}', [#{@reek_count[name].join(',')}])\n"
      end
      content = <<-EOS
        var g = new Bluff.Line('graph', "#{BLUFF_GRAPH_SIZE}");
        g.theme_pastel();
        g.title = 'Reek: code smells';
        #{data}
        g.labels = #{@labels.to_json};
        g.draw();
      EOS
      File.open(File.join(MetricFu.output_directory, 'reek.js'), 'w') {|f| f << content }
    end
  end

  class RoodiBluffGrapher < RoodiGrapher
    def graph!
      content = <<-EOS
        var g = new Bluff.Line('graph', "#{BLUFF_GRAPH_SIZE}");
        g.theme_pastel();
        g.title = 'Roodi: design problems';
        g.data('roodi', [#{@roodi_count.join(',')}]);
        g.labels = #{@labels.to_json};
        g.draw();
      EOS
      File.open(File.join(MetricFu.output_directory, 'roodi.js'), 'w') {|f| f << content }
    end
  end
end
