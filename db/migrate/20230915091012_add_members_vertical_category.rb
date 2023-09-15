class AddMembersVerticalCategory < ActiveRecord::Migration
  def up
    members_vm = VerticalMarket.create(name: 'Members', slug: 'members', ancestry_depth: 0)
    VerticalMarket.find_by_name('Friends').update_column(:ancestry, members_vm.id.to_s)
  end

  def down
    VerticalMarket.find_by_name('Members')&.destroy
    VerticalMarket.find_by_name('Friends')&.update_column(:ancestry, VerticalMarket.find_by_name('Specialty')&.id&.to_s)
  end
end
