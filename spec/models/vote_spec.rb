require 'spec_helper'

describe Vote do

  before do
    Factory(:state, abbreviation: 'NC')
    Factory(:zip, zip: 28801) #Find a way to fix this so automatically generated before user created
    @user = Factory(:user)
    @item = Factory(:item)
  end


  context "User has not voted on item" do

    it 'User Vote count for item/user should be zero' do
      UserVote.where(:item_id => @item.id, :user_id => @user.id).count.should == 0
    end

    context "User Votes thumbs up for item" do
      before do
        @previous_vote_count = UserVote.count
        Vote.record_vote(@user.id, @user.state, @user.zip, @user.birth_year, @item.id, 1)
        @user_vote = UserVote.where(:item_id => @item.id, :user_id => @user.id)
      end

      it 'Total vote count should increase by one' do
        UserVote.count.should == (@previous_vote_count + 1)
      end

      it 'User Vote record should exist for user and item' do
        @user_vote.count.should == 1
      end

      it 'User Vote should contan a vote of positive (1)' do
        @user_vote.first.vote.should == 1
      end
    end

    context "User has previously voted thumbs up for an item" do
      before do
        UserVote.create(:item_id => @item.id, :user_id => @user.id, :vote => 1)
        @current_user_vote = UserVote.where(:item_id => @item.id, :user_id => @user.id)
      end

      it 'Verify existing vote record created' do
        @current_user_vote.count.should == 1
        @current_user_vote.first.vote.should == 1
      end

      context 'Change vote to thumbs down' do
        before do
          Vote.record_vote(@user.id, @user.state, @user.zip, @user.birth_year, @item.id, -1)
          @new_user_vote = UserVote.where(:item_id => @item.id, :user_id => @user.id)
        end

        it 'Vote Count for item should be one' do
          @new_user_vote.count.should == 1
        end

        it 'User vote should now be thumbs down' do
          @new_user_vote.first.vote.should == -1
        end
      end

    end
  end
end
