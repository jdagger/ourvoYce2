require 'spec_helper'

describe Stat do

  describe "#find_row" do
    before do
      @birth_year = 1970
      @state = 'NC'
      @zip = '28801'
      @item = Factory(:item)
      @stat1 = Factory(:stat, :item_id => @item.id, :birth_year => @birth_year, :state => @state, :zip => @zip)
    end

    it 'check stat exists in database' do
      Stat.count.should == 1
    end

    it 'invalid birth year' do
      Stat.find_row(@item.id, @birth_year + 1, @zip).should be_nil
    end
    it 'invalid zip' do
      Stat.find_row(@item.id, @birth_year, '00000').should be_nil
    end
    it 'invalid item' do
      Stat.find_row(@item.id + 1, @birth_year, @zip).should be_nil
    end
    it 'valid' do
      Stat.find_row(@item.id, @birth_year, @zip).id.should == @stat1.id
    end
  end

  describe "#record_vote" do
    before do
      @birth_year = 1970
      @state = 'NC'
      @zip = '28801'
      @item = Factory(:item)
      _state = Factory(:state, :abbreviation => @state)
      _zip = Factory(:zip, :zip => @zip)
      @user = Factory(:user, :birth_year => @birth_year, :state => @state, :zip => @zip)
    end

    context "invalid input" do
      it 'item does not exist' do
        #Check item does not exist
        Item.where(:id => (@item.id + 1)).count.should == 0
        Stat.record_vote(@item.id + 1, @birth_year, @state, @zip, 0, 1).should be_nil
      end

      context 'previous vote' do
        it { Stat.record_vote(@item.id, @birth_year, @state, @zip, 'A', 1).should be_nil }
        it { Stat.record_vote(@item.id, @birth_year, @state, @zip, -2, 1).should be_nil }
        it { Stat.record_vote(@item.id, @birth_year, @state, @zip, 2, 1).should be_nil }
        it { Stat.record_vote(@item.id, @birth_year, @state, @zip, nil, 1).should be_true }
        it { Stat.record_vote(@item.id, @birth_year, @state, @zip, 0, 1).should be_true }
        it { Stat.record_vote(@item.id, @birth_year, @state, @zip, 1, 1).should be_true }
        it { Stat.record_vote(@item.id, @birth_year, @state, @zip, -1, 1).should be_true }
      end

      context 'invalid new vote' do
        it { Stat.record_vote(@item.id, @birth_year, @state, @zip, 1, 'A').should be_nil }
        it { Stat.record_vote(@item.id, @birth_year, @state, @zip, 1, -2).should be_nil }
        it { Stat.record_vote(@item.id, @birth_year, @state, @zip, 1, 2).should be_nil }
        it { Stat.record_vote(@item.id, @birth_year, @state, @zip, 1, nil).should be_nil }
        it { Stat.record_vote(@item.id, @birth_year, @state, @zip, 1, 1).should be_true }
        it { Stat.record_vote(@item.id, @birth_year, @state, @zip, 1, 0).should be_true }
        it { Stat.record_vote(@item.id, @birth_year, @state, @zip, 1, -1).should be_true }
      end
    end


    context 'stat does not exist' do
      before do
        @starting_count = Stat.count
      end

      it { @starting_count.should == 0 }

      context 'Vote thumbs up' do
        it 'counts should update correctly' do
          Stat.record_vote(@item.id, @birth_year, @state, @zip, nil, 1).should be_true
          stat = Stat.find_row(@item.id, @birth_year, @zip)
          stat.should_not be_nil
          stat.thumbs_up_vote_count.should == 1
          stat.thumbs_down_vote_count.should == 0
          stat.neutral_vote_count.should == 0
          stat.total_vote_count.should == 1
        end
      end

      context 'Vote thumbs down' do
        it 'counts should update correctly' do
          Stat.record_vote(@item.id, @birth_year, @state, @zip, nil, -1).should be_true
          stat = Stat.find_row(@item.id, @birth_year, @zip)
          stat.should_not be_nil
          stat.thumbs_up_vote_count.should == 0
          stat.thumbs_down_vote_count.should == 1
          stat.neutral_vote_count.should == 0
          stat.total_vote_count.should == 1
        end
      end

      context 'Vote neutral' do
        it 'counts should update correctly' do
          Stat.record_vote(@item.id, @birth_year, @state, @zip, nil, 0).should be_true
          stat = Stat.find_row(@item.id, @birth_year, @zip)
          stat.should_not be_nil
          stat.thumbs_up_vote_count.should == 0
          stat.thumbs_down_vote_count.should == 0
          stat.neutral_vote_count.should == 1
          stat.total_vote_count.should == 1
        end
      end
    end

    context 'stat already exists' do
      before do
        @thumbs_up_vote_count = 10
        @thumbs_down_vote_count = 20
        @neutral_vote_count = 30
        @total_vote_count = @thumbs_down_vote_count + @thumbs_up_vote_count + @neutral_vote_count
        @stat = Factory(:stat, :item_id => @item.id, :birth_year => @birth_year, :zip => @zip, :thumbs_up_vote_count => @thumbs_up_vote_count, :thumbs_down_vote_count => @thumbs_down_vote_count, :neutral_vote_count => @neutral_vote_count, :total_vote_count => @total_vote_count)
      end

      it 'verify stat record exists' do
        stat = Stat.find_row(@item.id, @birth_year, @zip)
        stat.should_not be_nil
        stat.thumbs_up_vote_count.should == @thumbs_up_vote_count
        stat.thumbs_down_vote_count.should == @thumbs_down_vote_count
        stat.neutral_vote_count.should == @neutral_vote_count
        stat.total_vote_count.should == @total_vote_count
      end

      context "not previously voted" do
        it 'voted thumbs up' do
          Stat.record_vote(@item.id, @birth_year, @state, @zip, nil, 1).should be_true
          stat = Stat.find_row(@item.id, @birth_year, @zip)
          stat.should_not be_nil
          stat.thumbs_up_vote_count.should == @thumbs_up_vote_count + 1
          stat.thumbs_down_vote_count.should == @thumbs_down_vote_count
          stat.neutral_vote_count.should == @neutral_vote_count
          stat.total_vote_count.should == @total_vote_count + 1 
        end
        it 'voted thumbs down' do
          Stat.record_vote(@item.id, @birth_year, @state, @zip, nil, -1).should be_true
          stat = Stat.find_row(@item.id, @birth_year, @zip)
          stat.should_not be_nil
          stat.thumbs_up_vote_count.should == @thumbs_up_vote_count
          stat.thumbs_down_vote_count.should == @thumbs_down_vote_count + 1
          stat.neutral_vote_count.should == @neutral_vote_count
          stat.total_vote_count.should == @total_vote_count + 1 
        end
        it 'voted neutral' do
          Stat.record_vote(@item.id, @birth_year, @state, @zip, nil, 0).should be_true
          stat = Stat.find_row(@item.id, @birth_year, @zip)
          stat.should_not be_nil
          stat.thumbs_up_vote_count.should == @thumbs_up_vote_count
          stat.thumbs_down_vote_count.should == @thumbs_down_vote_count
          stat.neutral_vote_count.should == @neutral_vote_count + 1
          stat.total_vote_count.should == @total_vote_count + 1 
        end
      end

      context "Previously voted thumbs up" do
        it 'voted thumbs up' do
          Stat.record_vote(@item.id, @birth_year, @state, @zip, 1, 1).should be_true
          stat = Stat.find_row(@item.id, @birth_year, @zip)
          stat.should_not be_nil
          stat.thumbs_up_vote_count.should == @thumbs_up_vote_count
          stat.thumbs_down_vote_count.should == @thumbs_down_vote_count
          stat.neutral_vote_count.should == @neutral_vote_count
          stat.total_vote_count.should == @total_vote_count
        end
        it 'voted thumbs down' do
          Stat.record_vote(@item.id, @birth_year, @state, @zip, 1, -1).should be_true
          stat = Stat.find_row(@item.id, @birth_year, @zip)
          stat.should_not be_nil
          stat.thumbs_up_vote_count.should == @thumbs_up_vote_count - 1
          stat.thumbs_down_vote_count.should == @thumbs_down_vote_count + 1
          stat.neutral_vote_count.should == @neutral_vote_count
          stat.total_vote_count.should == @total_vote_count
        end
        it 'voted neutral' do
          Stat.record_vote(@item.id, @birth_year, @state, @zip, 1, 0).should be_true
          stat = Stat.find_row(@item.id, @birth_year, @zip)
          stat.should_not be_nil
          stat.thumbs_up_vote_count.should == @thumbs_up_vote_count - 1
          stat.thumbs_down_vote_count.should == @thumbs_down_vote_count
          stat.neutral_vote_count.should == @neutral_vote_count + 1
          stat.total_vote_count.should == @total_vote_count
        end
      end

      context "Previously voted thumbs down" do
        it 'voted thumbs up' do
          Stat.record_vote(@item.id, @birth_year, @state, @zip, -1, 1).should be_true
          stat = Stat.find_row(@item.id, @birth_year, @zip)
          stat.should_not be_nil
          stat.thumbs_up_vote_count.should == @thumbs_up_vote_count + 1
          stat.thumbs_down_vote_count.should == @thumbs_down_vote_count - 1
          stat.neutral_vote_count.should == @neutral_vote_count
          stat.total_vote_count.should == @total_vote_count
        end
        it 'voted thumbs down' do
          Stat.record_vote(@item.id, @birth_year, @state, @zip, -1, -1).should be_true
          stat = Stat.find_row(@item.id, @birth_year, @zip)
          stat.should_not be_nil
          stat.thumbs_up_vote_count.should == @thumbs_up_vote_count
          stat.thumbs_down_vote_count.should == @thumbs_down_vote_count
          stat.neutral_vote_count.should == @neutral_vote_count
          stat.total_vote_count.should == @total_vote_count
        end
        it 'voted neutral' do
          Stat.record_vote(@item.id, @birth_year, @state, @zip, -1, 0).should be_true
          stat = Stat.find_row(@item.id, @birth_year, @zip)
          stat.should_not be_nil
          stat.thumbs_up_vote_count.should == @thumbs_up_vote_count
          stat.thumbs_down_vote_count.should == @thumbs_down_vote_count - 1
          stat.neutral_vote_count.should == @neutral_vote_count + 1
          stat.total_vote_count.should == @total_vote_count
        end
      end

      context "Previously voted neutral" do
        it 'voted thumbs up' do
          Stat.record_vote(@item.id, @birth_year, @state, @zip, 0, 1).should be_true
          stat = Stat.find_row(@item.id, @birth_year, @zip)
          stat.should_not be_nil
          stat.thumbs_up_vote_count.should == @thumbs_up_vote_count + 1
          stat.thumbs_down_vote_count.should == @thumbs_down_vote_count
          stat.neutral_vote_count.should == @neutral_vote_count - 1
          stat.total_vote_count.should == @total_vote_count
        end
        it 'voted thumbs down' do
          Stat.record_vote(@item.id, @birth_year, @state, @zip, 0, -1).should be_true
          stat = Stat.find_row(@item.id, @birth_year, @zip)
          stat.should_not be_nil
          stat.thumbs_up_vote_count.should == @thumbs_up_vote_count
          stat.thumbs_down_vote_count.should == @thumbs_down_vote_count + 1
          stat.neutral_vote_count.should == @neutral_vote_count - 1
          stat.total_vote_count.should == @total_vote_count
        end
        it 'voted neutral' do
          Stat.record_vote(@item.id, @birth_year, @state, @zip, 0, 0).should be_true
          stat = Stat.find_row(@item.id, @birth_year, @zip)
          stat.should_not be_nil
          stat.thumbs_up_vote_count.should == @thumbs_up_vote_count
          stat.thumbs_down_vote_count.should == @thumbs_down_vote_count
          stat.neutral_vote_count.should == @neutral_vote_count
          stat.total_vote_count.should == @total_vote_count
        end
      end
    end
  end
end

