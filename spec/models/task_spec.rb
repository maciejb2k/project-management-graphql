RSpec.describe Task, type: :model do
  describe "factory" do
    it { expect(build(:task)).to be_valid }
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
