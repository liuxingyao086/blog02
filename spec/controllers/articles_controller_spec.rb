require 'rails_helper'
                               
RSpec.describe ArticlesController do
  
  let(:users) { create_list(:user, 5) }
  it '创建文章' do   #
    a = FactoryBot.create_list(:article,5)
    p a
  end
end
