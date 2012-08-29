module ApplicationHelper
  def twitterized_type(type)
    case type
    when :alert
      "warning"
    when :error
      "error"
    when :notice
      "info"
    when :success
      "success"
    else
      type.to_s
    end
  end

  def heatmap(histogram={})
    html = %{<div class="heatmap">}
    path = histogram[path]
    _max = histogram.map{|k,v| histogram[k]}.max * 2
    histogram.keys.sort{|a,b| histogram[a] <=> histogram[b]}.reverse.each do |k|
      tag = Tag.find_by_friendly_name(k) #need this so I can href to tag path below
      next if histogram[k] < 1
      _size = (((histogram[k] / histogram.map{|key,val| histogram[key]}.sum.to_f) * 100) + 5).to_i
      _heat = sprintf("%02x" % (255 - (_size * 25)))
      html << %{
        <div class="heatmap_element" style="color: ##{_heat}#{_heat};
            font-size: #{_size}px;"><a href="/tag/#{tag.path}">#{k}</a></div>
      }
    end
    html << %{<br style="clear: both;" /></div>}
  end

  def sort_link(title, column, options = {})
    condition = options[:unless] if options.has_key?(:unless)
    sort_dir = params[:d] == 'up' ? 'down' : 'up'
    link_to_unless condition, title, request.parameters.merge( {:c => column, :d => sort_dir} ), :class => "sort-link #{params[:c] == column.to_s ? params[:d] : '' }"
  end
end
