require 'spec_helper'

describe Item do
  describe '#record_vote' do

    describe 'check return values' do 
      before do
        @item = Factory(:item)
      end
      context "should return null if item does not exist" do
        it 'verify record does not exist' do 
          Item.where(:id => 1000).count.should == 0 
        end
        it { Item.record_vote(1000, nil, 1).should be_nil }
      end

      context "should return null if invalid vote passed in" do
        it { Item.record_vote(@item.id, nil, 2).should be_nil }
        it { Item.record_vote(@item.id, nil, -2).should be_nil }
        it { Item.record_vote(@item.id, nil, nil).should be_nil }
        it { Item.record_vote(@item.id, 2, 1).should be_nil }
        it { Item.record_vote(@item.id, -2, 1).should be_nil }
      end

      context "should return true on success" do
        it 'Verify record exists' do
          Item.where(:id => @item.id).count.should == 1
        end
        it { Item.record_vote(@item.id, nil, 1).should be_true }
      end
    end

    context "item has no votes" do
      before do
        @item = Factory(:item)
      end
      it 'test record setup and counts' do
        item = Item.find(@item.id)
        item.should_not be_nil
        item.thumbs_up_vote_count.should == 0
        item.thumbs_down_vote_count.should == 0
        item.neutral_vote_count.should == 0
        item.total_vote_count.should == 0
      end

      it 'user votes thumbs up' do
        Item.record_vote(@item.id, nil, 1)
        item = Item.find(@item.id)
        item.thumbs_up_vote_count.should == 1
        item.thumbs_down_vote_count.should == 0
        item.neutral_vote_count.should == 0
        item.total_vote_count.should == 1
      end

      it 'user votes thumbs down' do
        Item.record_vote(@item.id, nil, -1)
        item = Item.find(@item.id)
        item.thumbs_up_vote_count.should == 0
        item.thumbs_down_vote_count.should == 1 
        item.neutral_vote_count.should == 0
        item.total_vote_count.should == 1
      end

      it 'user votes neutral' do
        Item.record_vote(@item.id, nil, 0)
        item = Item.find(@item.id)
        item.thumbs_up_vote_count.should == 0
        item.thumbs_down_vote_count.should == 0
        item.neutral_vote_count.should == 1
        item.total_vote_count.should == 1
      end
    end

    context 'item has votes recorded' do
      before do
        @thumbs_up_vote_count = 20
        @thumbs_down_vote_count = 30
        @neutral_vote_count = 40
        @total_vote_count = @thumbs_up_vote_count + @thumbs_down_vote_count + @neutral_vote_count
        @item = Factory(:item, :thumbs_up_vote_count => @thumbs_up_vote_count, :thumbs_down_vote_count => @thumbs_down_vote_count, :neutral_vote_count => @neutral_vote_count, :total_vote_count => @total_vote_count)
      end
      it { Item.find(@item.id).should_not be_nil }

      context 'User does not change vote' do
        it 'keep vote at thumbs up' do
          result = Item.record_vote(@item.id, 1, 1)
          result.should be_true
          item = Item.find(@item.id)
          item.thumbs_up_vote_count.should == @thumbs_up_vote_count
          item.thumbs_down_vote_count.should == @thumbs_down_vote_count
          item.neutral_vote_count.should == @neutral_vote_count
          item.total_vote_count.should == @total_vote_count
        end
        it 'keep vote at thumbs down' do
          result = Item.record_vote(@item.id, -1, -1)
          result.should be_true
          item = Item.find(@item.id)
          item.thumbs_up_vote_count.should == @thumbs_up_vote_count
          item.thumbs_down_vote_count.should == @thumbs_down_vote_count
          item.neutral_vote_count.should == @neutral_vote_count
          item.total_vote_count.should == @total_vote_count
        end
        it 'keep vote at neutral' do
          result = Item.record_vote(@item.id, 0, 0)
          result.should be_true
          item = Item.find(@item.id)
          item.thumbs_up_vote_count.should == @thumbs_up_vote_count
          item.thumbs_down_vote_count.should == @thumbs_down_vote_count
          item.neutral_vote_count.should == @neutral_vote_count
          item.total_vote_count.should == @total_vote_count
        end

        context 'User changes vote' do
          it 'changes from thumbs up to thumbs down' do
            result = Item.record_vote(@item.id, 1, -1)
            result.should be_true
            item = Item.find(@item.id)
            item.thumbs_up_vote_count.should == (@thumbs_up_vote_count - 1)
            item.thumbs_down_vote_count.should == (@thumbs_down_vote_count + 1)
            item.neutral_vote_count.should == @neutral_vote_count
            item.total_vote_count.should == @total_vote_count
          end
          it 'changes from thumbs up to neutral' do
            result = Item.record_vote(@item.id, 1, 0)
            result.should be_true
            item = Item.find(@item.id)
            item.thumbs_up_vote_count.should == (@thumbs_up_vote_count - 1)
            item.thumbs_down_vote_count.should == @thumbs_down_vote_count
            item.neutral_vote_count.should == (@neutral_vote_count + 1)
            item.total_vote_count.should == @total_vote_count
          end
          it 'changes from neutral to thumbs up' do
            result = Item.record_vote(@item.id, 0, 1)
            result.should be_true
            item = Item.find(@item.id)
            item.thumbs_up_vote_count.should == (@thumbs_up_vote_count + 1)
            item.thumbs_down_vote_count.should == @thumbs_down_vote_count
            item.neutral_vote_count.should == (@neutral_vote_count - 1)
            item.total_vote_count.should == @total_vote_count
          end
          it 'changes from neutral to thumbs down' do
            result = Item.record_vote(@item.id, 0, -1)
            result.should be_true
            item = Item.find(@item.id)
            item.thumbs_up_vote_count.should == @thumbs_up_vote_count
            item.thumbs_down_vote_count.should == (@thumbs_down_vote_count + 1)
            item.neutral_vote_count.should == (@neutral_vote_count - 1)
            item.total_vote_count.should == @total_vote_count
          end
          it 'changes from thumbs down to neutral' do
            result = Item.record_vote(@item.id, -1, 0)
            result.should be_true
            item = Item.find(@item.id)
            item.thumbs_up_vote_count.should == @thumbs_up_vote_count
            item.thumbs_down_vote_count.should == (@thumbs_down_vote_count - 1)
            item.neutral_vote_count.should == (@neutral_vote_count + 1)
            item.total_vote_count.should == @total_vote_count
          end
          it 'changes from thumbs down to thumbs up' do
            result = Item.record_vote(@item.id, -1, 1)
            result.should be_true
            item = Item.find(@item.id)
            item.thumbs_up_vote_count.should == (@thumbs_up_vote_count + 1)
            item.thumbs_down_vote_count.should == (@thumbs_down_vote_count - 1)
            item.neutral_vote_count.should == @neutral_vote_count
            item.total_vote_count.should == @total_vote_count
          end
        end
      end
    end
  end
end
