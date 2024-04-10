# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           default(""), not null
#  username        :string           default(""), not null
#  first_name      :string           default(""), not null
#  last_name       :string           default(""), not null
#  password_digest :string           default(""), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

RSpec.describe User, type: :model do
  describe "factory" do
    it { expect(build(:user)).to be_valid }
  end
end
