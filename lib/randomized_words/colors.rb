NAMES = %w(black silver gray white maroon red purple fuchsia green lime olive
           yellow navy blue teal aqua orange aliceblue antiquewhite aquamarine azure beige
           bisque blanchedalmond blueviolet brown burlywood cadetblue chartreuse chocolate
           coral cornflowerblue cornsilk crimson cyan darkblue darkcyan darkgoldenrod
           darkgray darkgreen darkgrey darkkhaki darkmagenta darkolivegreen darkorange
           darkorchid darkred darksalmon darkseagreen darkslateblue darkslategray
           darkslategrey darkturquoise darkviolet deeppink deepskyblue dimgray dimgrey
           dodgerblue firebrick floralwhite forestgreen gainsboro ghostwhite gold
           goldenrod greenyellow grey honeydew hotpink indianred indigo ivory khaki
           lavender lavenderblush lawngreen lemonchiffon lightblue lightcoral lightcyan
           lightgoldenrodyellow lightgray lightgreen lightgrey lightpink lightsalmon
           lightseagreen lightskyblue lightslategray lightslategrey lightsteelblue
           lightyellow limegreen linen magenta mediumaquamarine mediumblue mediumorchid
           mediumpurple mediumseagreen mediumslateblue mediumspringgreen mediumturquoise
           mediumvioletred midnightblue mintcream mistyrose moccasin navajowhite oldlace
           olivedrab orangered orchid palegoldenrod palegreen paleturquoise palevioletred
           papayawhip peachpuff peru pink plum powderblue rosybrown royalblue saddlebrown
           salmon sandybrown seagreen seashell sienna skyblue slateblue slategray
           slategrey snow springgreen steelblue tan thistle tomato turquoise violet wheat
           whitesmoke yellowgreen)

module RandomizedWords
  class Colors
    include SeededRandom

    # Get a CSS color name.
    #
    #    name => "snow"
    #
    def name
      NAMES.sample(random: random)
    end

    # Get an RGB color in 0-255 integer CSV. Prefer brighter, more saturated colors.
    #
    #    get_rgb => "120,20,248"
    #
    def rgb
      h, s, l = hsl.split(',').map {|val| linmap(val.to_i, 0, 255, 0.0, 1.0)}

      q = l < 0.5 ?
        l * (1 + s) :
        (l + s) - (l * s)
      p = (2 * l) - q

      r = hue_to_rgb(p, q, h + 0.333)
      g = hue_to_rgb(p, q, h)
      b = hue_to_rgb(p, q, h - 0.333)

      [(r * 255).round, (g * 255).round, (b * 255).round].map(&:to_s).join(',')
    end

    # favor high saturation and lightness
    def hsl
      h = random.rand(256)
      s = 200 + random.rand(56)
      l = 200 + random.rand(56)
      [h, s, l].map(&:to_s).join(',')
    end

    def hex
      r, g, b = rgb.split(',').map(&:to_i)
      "%s%s%s" % [hex_format(r), hex_format(g), hex_format(b)]
    end

    private

    def hex_format(int)
      s = int.to_s(16).upcase
      s.size == 1 ? "0" + s : s
    end

    def linmap(x, in_min, in_max, out_min, out_max)
      in_min *= 1.0
      in_max *= 1.0
      out_min *= 1.0
      out_max *= 1.0
      return ((x - in_min) * (out_max - out_min) + out_min * (in_max - in_min)) / (in_max - in_min);
    end

    def hue_to_rgb(p, q, t)
      if t < 0
        t += 1
      end

      if t > 1
        t -= 1
      end

      if t < 0.16666
        p + (q - p) * 6.0 * t
      elsif t < 0.5
        q
      elsif t < 0.66666
        p + (q - p) * (0.66666 - t) * 6.0
      else
        p
      end
    end
  end
end
