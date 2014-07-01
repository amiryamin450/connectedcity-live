module FavoritesHelper
  def fav_count(vm)
    count = @favorites.count { |f| f.category == vm.slug}
    if  count > 0
      " - (#{count})"
    else
      ''
    end
  end
end