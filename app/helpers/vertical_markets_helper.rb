module VerticalMarketsHelper

  def vm_menu(vertical_markets)
    vms = vertical_markets.dup

    output = ""
    output += "<ul class='main-nav'>"
    output += "<li class='small active'>"
    output += "<div>"
    output += "<a href='#'><i class='account'></i>account</a>"
    output += "<div class='sub-drop'>"
    output += "<ul>"
    output += "<li>"
    output += "<a href='#{new_user_session_path}'>login</a>"
    output += "</li>"
    output += "<li>"
    output += "<a href='#{new_user_registration_path}'>sign up</a>"
    output += "</li>"
    output += "</ul>"
    output += "</div>"
    output += "</div>"
    output += "</li>"

      output += "<li><div><a href='#{@base_path}' class='#{"active " if request.path == @base_path }'>Home</a>"
      vms.each_with_index do |vm, index|
        if index == 4
          output += "</div>"
          output += "</li>"

          output += "</ul>"

          output += "<div class='add-nav'>"
          output += "<a href='#' class='add-opener'>more</a>"
          output += "<div class='add-drop'>"
          output += "<ul>"
        end
        output += "<li><div><a href='#{@base_path}guide/#{vm.slug}'><i class='#{vm.name}'></i>#{vm.name}</a>"
        if vm.has_children?
          output += "<div class='sub-drop'>"
          output += "<ul>"
          vm.children.each do |child, index|
            sub_path = "#{@base_path}guide/#{child.slug}"
            output += "<li><a href='#{sub_path}'>#{child.name}</a></li>"
          end
          output += "</ul>"
          output += "</div>"
        end
      end
      output += "</div>"
      output += "</li>"

    output += "</ul>"
    output += "</div>"
    output += "</div>"
    output += "<ul class='side-nav'>"
    output += "<li><div><a href='/employment-opportunities'><i class='jobs'></i>Jobs</a></div></li>"
    output += "<li class='right bottom'><div><a href='/classifieds'><i class='classified'></i>Classifieds</a></div></li>"
    output += "<li class='right'><div><a href='#{@base_path}news'><i class='city'></i>City News</a></div></li>"
    output += "</ul>"

    render :inline => output
  end

end
