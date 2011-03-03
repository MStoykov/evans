require 'spec_helper'

describe Reply do
  it { should belong_to(:topic) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:topic_id) }
  it { should validate_presence_of(:user_id) }

  it { should_not allow_mass_assignment_of(:user_id) }
  it { should_not allow_mass_assignment_of(:topic_id) }

  it "can be edited by its owner or by an admin" do
    reply = Reply.make

    reply.can_be_edited_by?(reply.user).should be_true
    reply.can_be_edited_by?(Factory(:admin)).should be_true

    reply.can_be_edited_by?(nil).should be_false
    reply.can_be_edited_by?(Factory(:user)).should be_false
  end

  it "can tell on which page of the topic it is" do
    topic  = Topic.make
    first  = Reply.make :topic => topic
    second = Reply.make :topic => topic
    third  = Reply.make :topic => topic

    Reply.stub :per_page => 2

    first.page_in_topic.should == 1
    second.page_in_topic.should == 1
    third.page_in_topic.should == 2
  end
end