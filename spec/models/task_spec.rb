# == Schema Information
#
# Table name: tasks
#
#  id             :bigint           not null, primary key
#  title          :string           not null
#  estimated_time :integer
#  delivered_time :integer
#  status         :string           default("todo"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  project_id     :bigint           not null
#
RSpec.describe Task, type: :model do
  describe "factory" do
    let!(:user) { create(:user) }
    let!(:project) { create(:project, user:) }

    it { expect(build(:task, project:)).to be_valid }
  end

  describe "validations" do
    describe "title" do
      it { is_expected.to validate_presence_of(:title) }
    end

    describe "status" do
      it { is_expected.to validate_presence_of(:status) }
      it do
        is_expected.to(
          validate_inclusion_of(:status)
          .in_array(Task::STATUS_OPTIONS)
        )
      end
    end

    describe "estimated_time" do
      it do
        is_expected.to(
          validate_numericality_of(:estimated_time)
          .only_integer
          .is_greater_than_or_equal_to(0)
          .allow_nil
        )
      end
    end

    describe "delivered_time" do
      it do
        is_expected.to(
          validate_numericality_of(:delivered_time)
          .only_integer
          .is_greater_than_or_equal_to(0)
          .allow_nil
        )
      end
    end
  end
end
