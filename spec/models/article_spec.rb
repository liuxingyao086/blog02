require 'rails_helper'

RSpec.describe User, type: :model do
  # 
  let(:user) { create(:user) }

  let(:users) { create_list(:user, 20) }
  it '创建user' do   #
    
    expect(user.avatar_upload).to be
   
  end

end
