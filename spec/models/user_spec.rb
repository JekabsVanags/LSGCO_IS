require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build :user }

  it("should display test user") do
    puts user.name
    puts user.email
  end
end
