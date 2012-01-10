require 'scruffy'

module Sinatra
  # Sinatra::Graph is an extension that wraps Scruffy into Sinatra for maximum DSL goodness!
  module Graph
    # Those are the graph types that can be called from inside the block as functions.
    GRAPH_TYPES = [:all_smiles, :area, :bar, :line, :pie]

    # Declares a route for a graph. Define the title on the first method and it will be 'url-fied'. You can optionally define a prefix too.
    #
    # Inside the block you can call the following methods: all_smiles, area, bar, line and pie. Pass a title and an array (hash if using a pie) as parameters.
    #
    #   graph "Our Business", :prefix => '/graphs' do
    #     area "Buys", [1,5,2,3,4]
    #     bar "Sales", [5,2,6,2,1]
    #   end
    #
    # This graph will be served on /graphs/our_business.svg
    def graph(title, options = {}, &block)
      prefix = options[:prefix]
      get "#{prefix}/#{filename(title)}.svg" do
        content_type "image/svg+xml"

        graph = Scruffy::Graph.new(:theme => Scruffy::Themes::Polar.new)

        @graph = graph
        GRAPH_TYPES.each do |type|
          instance_eval <<-EVAL
            def #{type}(title, values, options = {}, &block)
              @graph.add :#{type}, title, values, options, block
            end
          EVAL
        end

        instance_eval(&block)
        graph.title = title

        if options[:type].to_s == 'pie'
          graph.renderer = renderer(options[:type])
        else
          Scruffy::Renderers::Standard.new
        end
        #graph.render(:min_value => 0).gsub(/viewBox\=\"([0-9]+)\s100\s([0-9]+)\s200\"/, 'viewBox="0 0 \1 \2"')
        graph.render(:min_value => 0).gsub(/viewBox\=\"([0-9]+)\s100\s([0-9]+)\s200\"/, '')
      end
    end

    def filename(title)
      title.gsub(/[^a-zA-Z0-9_\s]/, '').gsub(/\s/, '_').downcase
    end

    def renderer(option)
      case option
        when 'pie': Scruffy::Renderers::Pie.new
        else Scruffy::Renderers::Standard.new
      end
    end
  end

  register Graph
end

module Scruffy::Layers
  class Base
    def initialize(options = {})
      @title = options.delete(:title) || ''
      @preferred_color = options.delete(:color)
      @relevant_data = options.delete(:relevant_data) || true
      @points = options.delete(:points) || []
      @points.extend Scruffy::Helpers::PointContainer unless @points.kind_of? Scruffy::Helpers::PointContainer
      
      options[:stroke_width] ||= 1
      options[:dots] ||= true
      options[:shadow] ||= false
      options[:style] ||= false
      options[:relativestroke] ||= false
      
      @options = options
    end
  end
  class Line < Base
    # ==Scruffy::Layers::Line
    #
    # Author:: Brasten Sager
    # Date:: August 7th, 2006
    #
    # Line graph.
    #
    def draw(svg, coords, options={})

      # Include options provided when the object was created
      options.merge!(@options)

      stroke_width = (options[:relativestroke]) ? relative(options[:stroke_width]) : options[:stroke_width]
      style = (options[:style]) ? options[:style] : 'fill:none;stroke:black;stroke-width:3'

      if options[:shadow]
        svg.g(:class => 'shadow', :transform => "translate(#{relative(0.5)}, #{relative(0.5)})") {
          svg.polyline( :points => stringify_coords(coords).join(' '), :fill => 'transparent',
                       :stroke => 'black', 'stroke-width' => stroke_width,
                       :style => 'fill-opacity: 0; stroke-opacity: 0.35' )

          if options[:dots]
            coords.each { |coord| svg.circle( :cx => coord.first, :cy => coord.last + relative(0.9), :r => stroke_width,
                                             :style => "stroke-width: #{stroke_width}; stroke: black; opacity: 0.35;" ) }
          end
        }
      end


      svg.polyline( :points => stringify_coords(coords).join(' '), :fill => 'none', :stroke => @color.to_s,
                   'stroke-width' => stroke_width, :style => "fill:none;stroke-width:#{stroke_width};stroke:#{color.to_s};" )

      if options[:dots]
        coords.each { |coord| svg.circle( :cx => coord.first, :cy => coord.last, :r => stroke_width,
                                         :style => "stroke-width: #{stroke_width}; stroke: #{color.to_s}; fill: #{color.to_s}" ) }
      end

    end
  end
end


module Scruffy::Themes
  class Polar < Base
    def initialize
      super({
              :background => [:white, :white],
              :marker => '#111111',
              :colors => %w(#ff6600 #999999 #ff0000) # light orange, orange, grey, red
            })
    end
  end
end

module Scruffy
  module Components
    class Grid < Base
      attr_accessor :markers
      
      def draw(svg, bounds, options={})
        markers = (options[:markers] || self.markers) || 5
        
        stroke_width = options[:stroke_width]
        
        (0...markers).each do |idx|
          marker = ((1 / (markers - 1).to_f) * idx) * bounds[:height]
          svg.line(:x1 => 0, :y1 => marker, :x2 => bounds[:width], :y2 => marker, :style => "stroke: #{options[:theme].marker.to_s}; stroke-width: #{stroke_width};")
        end
      end
    end
  end
end

