require 'rails_helper'

RSpec.describe Invite, type: :model do
  it('should return an error if not a valid rank') do
    expect { Invite.new(rank: 'ERRORS') }.to raise_error(ArgumentError)
  end

  it('should raise an error if no unit and event is referenced') do
    expect { Invite.new.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
