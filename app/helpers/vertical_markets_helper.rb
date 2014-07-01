module VerticalMarketsHelper

  def vm_menu(vertical_markets)

    vms = vertical_markets.dup

    index = nil

    vms.each_with_index do |vm, i|
      if @vertical_market && vm.slug == @vertical_market.slug
        vm.menu_li_class = 'active'
        vm.menu_link_class = 'active'
        index = i-1 if i != 0
      end
    end

    vms[index].menu_li_class = 'before-active' unless index.nil?

    first = vms.shift
    last = vms.pop
    output = ""
    output += "<li class='first #{ first.menu_li_class }'><a href='#{@base_path}guide/#{first.slug}' class='#{ first.menu_link_class }'>#{first.name}</a></li>"
    vms.each do |vm|
      output += "<li class='#{ vm.menu_li_class }'><a href='#{@base_path}guide/#{vm.slug}' class='#{ vm.menu_link_class }'>#{vm.name}</a>"
      if vm.has_children?
        output += "<ul id='vm-#{vm.id}' class='child-menu' style='display: #{"none" unless (@vertical_market && vm.children.find {|f| f[:slug] == @vertical_market.slug}) or (@vertical_market && vm.slug == @vertical_market.slug)};'>"
        vm.children.each do |child|
          output += "<li><a href='#{@base_path}guide/#{child.slug}'>#{child.name}</a></li>"
        end
        output += "</ul>"
      end
      output += "</li>"
    end
    output += "<li class='last #{ last.menu_li_class }'><a href='#{@base_path}guide/#{last.slug}' class='#{ last.menu_link_class  }'>#{last.name}</a></li>"
    render :inline => output

  end


end
