require 'spec_helper'

describe UserVote do
  describe "#record_vote" do
    before do
      Factory(:state, abbreviation: 'NC')
      Factory(:zip, zip: 28801) #Find a way to fix this so automatically generated before user created
      @user = Factory(:user)
      @item = Factory(:item)
    end
    context "User has not voted on item" do
      it 'User Vote count for item/user should be zero' do
        @new_vote = 1
        UserVote.where(:item_id => @item.id, :user_id => @user.id).count.should == 0
      end

      context "User votes for item" do
        before do
          @previous_vote_count = UserVote.count
          UserVote.record_vote(@user.id, @item.id, @new_vote)
          @user_vote = UserVote.where(:item_id => @item.id, :user_id => @user.id)
        end

        it 'Total vote count should increase by one' do
          UserVote.count.should == (@previous_vote_count + 1)
        end

        it 'User Vote record should exist for user and item' do
          @user_vote.count.should == 1
        end

        it 'User Vote should contan a vote of positive (1)' do
          @user_vote.first.vote.should == @new_vote
        end
      end

      context "User has previously voted thumbs up for an item" do
        before do
          @current_vote = 1
          @new_vote = -1
          UserVote.create(:item_id => @item.id, :user_id => @user.id, :vote => @current_vote)
          @current_user_vote = UserVote.where(:item_id => @item.id, :user_id => @user.id)
        end

        it 'Verify test variables are set up correctly' do
          @current_vote.should_not == @new_vote
          @current_user_vote.count.should == 1
          @current_user_vote.first.vote.should == @current_vote
        end

        context 'Change vote' do
          before do
            @initial_vote_count = UserVote.count
            UserVote.record_vote(@user.id, @item.id, @new_vote)
            @new_user_vote = UserVote.where(:item_id => @item.id, :user_id => @user.id)
          end

          it 'Total user vote could should be unchanged' do
            UserVote.count.should == @initial_vote_count
          end

          it 'User vote count for item should be one' do
            @new_user_vote.count.should == 1
          end

          it 'User vote should now be new value' do
            @new_user_vote.first.vote.should == @new_vote
          end
        end
      end
    end
  end
end
