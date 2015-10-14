module VerticalMarketsHelper

  def vm_menu(vertical_markets)

    vms = vertical_markets.dup

    index = nil

    # make sure that parents of child tabs are marked as active
    vms.each_with_index do |vm, i|
      if @vertical_market
        if vm.slug == @vertical_market.slug or vm.children.where(slug: @vertical_market.slug).exists?
          vm.menu_li_class = 'active'
          vm.menu_link_class = 'active'
          index = i-1 if i != 0
        end
      end
    end

    vms[index].menu_li_class = 'before-active' unless index.nil?

    if request.path == '/employment-opportunities'
      vms.last.menu_li_class = 'before-active'
    end

    # last = vms.pop
    output = ""
    output += "<li class='first #{"active " if request.path == @base_path }#{"before-active" if vms[0].menu_li_class == 'active' }'><a href='#{@base_path}' class='#{"active " if request.path == @base_path }'><i class='icon-home'></i> Home</a></li>"
    vms.each do |vm|
      output += "<li class='#{ vm.menu_li_class }'><a href='#{@base_path}guide/#{vm.slug}' class='#{ vm.menu_link_class }'>#{vm.name}</a>"
      if vm.has_children?
        output += "<ul id='vm-#{vm.id}' class='child-menu' style='display: #{"none" unless (@vertical_market && vm.children.find {|f| f[:slug] == @vertical_market.slug}) or (@vertical_market && vm.slug == @vertical_market.slug)};'>"
        vm.children.each do |child|
          sub_path = "#{@base_path}guide/#{child.slug}"
          output += "<li><a class='#{"sub-active" if request.path == sub_path }' href='#{sub_path}'>#{child.name}</a></li>"
        end
        output += "</ul>"
      end
      output += "</li>"
    end
    output += "<li class='#{"active" if request.path == '/employment-opportunities'}#{"before-active" if request.path == '/classifieds'}'><a href='/employment-opportunities' class='#{"active" if request.path == '/employment-opportunities'}'>Employment</a></li>"
    output += "<li class='#{"active" if request.path == '/classifieds'}#{"before-active" if request.path == '/city-news-guide'}'><a href='/classifieds' class='#{"active" if request.path == '/classifieds'}'>Classifieds</a></li>"

    output += "<li class='last #{"active" if request.path == "#{@base_path}news" or request.path == '/city-news-guide'}'><a href='#{@base_path}news' class='#{"active" if request.path == "#{@base_path}news" or request.path == '/city-news-guide'}'>City News</a></li>"

    # binding.pry

    render :inline => output

  end


end
