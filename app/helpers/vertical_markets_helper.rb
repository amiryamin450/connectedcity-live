module VerticalMarketsHelper

  def vm_menu(vertical_markets)
    vms = vertical_markets.dup

    output = ""
    output += "<ul class='main-nav'>"
    output += "<li class='small'><div><a href='#{@base_path}' class='#{"active " if request.path == @base_path }'>Home</a></div></li>"
    vms.each do |vm|
      output += "<li><div><a href='#{@base_path}guide/#{vm.slug}'><i class='#{vm.name}'></i>#{vm.name}</a>"
      if vm.has_children?
        output += "<div class='sub-drop'>"
        output += "<ul>"
        vm.children.each do |child|
          sub_path = "#{@base_path}guide/#{child.slug}"
          output += "<li><a href='#{sub_path}'>#{child.name}</a></li>"
        end
        output += "</ul>"
        output += "</div>"
      end
      output += "</div>"

    end
    output += "</li>"

    output += "</ul>"

    output += "<ul class='side-nav'>"
    output += "<li><div><a href='/employment-opportunities'><i class='jobs'></i>Jobs</a></div></li>"
    output += "<li><div><a href='/classifieds'><i class='classified'></i>Classifieds</a></div></li>"
    output += "<li><div><a href='#{@base_path}news'><i class='city'></i>City News</a></div></li>"
    output += "</ul>"

    render :inline => output
  end

end
