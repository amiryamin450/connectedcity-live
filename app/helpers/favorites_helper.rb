module FavoritesHelper
  def fav_count(vm)
    count = @favorites.count { |f| f.category == vm.slug }
    if vm.has_children?
      vm.children.each do |child|
        count += @favorites.count { |f| f.category == child.slug }
      end
    end
    if  count > 0
      " - (#{count})"
    else
      ''
    end
  end

  def fav_count_num(vm)
        count = @favorites.count { |f| f.category == vm.slug }
    if vm.has_children?
      vm.children.each do |child|
        count += @favorites.count { |f| f.category == child.slug }
      end
    end
    count 
  end

  def fav_categories(vm)
    items = @favorites.select { |f| f.category == vm.slug }
    if vm.has_children?
      vm.children.each do |child|
        items += @favorites.select { |f| f.category == child.slug }
      end
    end
    items
  end

  def fav_link(vm)
    if user_signed_in?
      "/user/#{current_user.id}/favorites/#vm-#{vm.id}"
    else
      "#"
    end
  end

end