class ConfirmAllUsers < ActiveRecord::Migration[7.0]
  def change
    User.find_each do |user|
      if user.confirmed_at.nil?
        user.confirm
        if user.save
          print '.'
        else
          print '#'
        end
      end
    end
  end
end
